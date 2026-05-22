#!/usr/bin/env python3
"""Update public publication data from ORCID, Crossref, and arXiv."""

from __future__ import annotations

import argparse
import html
import json
import re
import time
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any


ORCID_ID = "0000-0002-8696-0920"
CONTACT_EMAIL = "ethungshan.shitiri@upc.edu"
ARXIV_AUTHOR = "Ethungshan Shitiri"
USER_AGENT = (
    "ethungshanshitiri-bio-publication-updater/1.0 "
    f"(mailto:{CONTACT_EMAIL})"
)


def fetch_json(url: str, headers: dict[str, str] | None = None) -> dict[str, Any]:
    request_headers = {"User-Agent": USER_AGENT, "Accept": "application/json"}
    if headers:
        request_headers.update(headers)
    req = urllib.request.Request(url, headers=request_headers)
    with urllib.request.urlopen(req, timeout=30) as response:
        return json.load(response)


def fetch_text(url: str) -> str:
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": USER_AGENT,
            "Accept": "application/atom+xml, application/xml, text/xml",
        },
    )
    with urllib.request.urlopen(req, timeout=30) as response:
        return response.read().decode("utf-8")


def clean_text(value: str | None) -> str:
    if not value:
        return ""
    value = html.unescape(value)
    value = re.sub(r"<[^>]+>", "", value)
    value = re.sub(r"\s+", " ", value)
    return value.strip()


def normalize_doi(value: str | None) -> str:
    if not value:
        return ""
    value = value.strip()
    value = re.sub(r"^https?://(dx\.)?doi\.org/", "", value, flags=re.I)
    value = re.sub(r"^doi:\s*", "", value, flags=re.I)
    return value.strip().lower()


def normalize_title(value: str | None) -> str:
    value = clean_text(value).lower()
    return re.sub(r"[^a-z0-9]+", "", value)


def date_parts_to_iso(parts: list[int] | None) -> str:
    if not parts:
        return ""
    year = parts[0]
    month = parts[1] if len(parts) > 1 else 1
    day = parts[2] if len(parts) > 2 else 1
    return f"{year:04d}-{month:02d}-{day:02d}"


def orcid_date_to_iso(value: dict[str, Any] | None) -> str:
    if not value:
        return ""
    year = ((value.get("year") or {}).get("value") or "").strip()
    month = ((value.get("month") or {}).get("value") or "").strip() or "1"
    day = ((value.get("day") or {}).get("value") or "").strip() or "1"
    if not year:
        return ""
    return f"{int(year):04d}-{int(month):02d}-{int(day):02d}"


def format_author(author: dict[str, Any]) -> str:
    family = clean_text(author.get("family"))
    given = clean_text(author.get("given"))
    if not family:
        return clean_text(author.get("name"))
    initials = ""
    for part in given.replace("-", " ").split():
        if part:
            initials += f"{part[0]}."
    return clean_text(f"{initials} {family}")


def section_for(record_type: str, source: str) -> str:
    record_type = (record_type or "").lower()
    if source == "arXiv":
        return "preprints"
    if record_type in {"journal-article", "article", "journal"}:
        return "journal_articles"
    if record_type in {"book-chapter", "book", "book-section"}:
        return "book_chapters"
    if record_type in {"conference-paper", "proceedings-article", "conference"}:
        return "conference_papers"
    return "other"


def extract_external_ids(summary: dict[str, Any]) -> dict[str, str]:
    ids: dict[str, str] = {}
    external_ids = (summary.get("external-ids") or {}).get("external-id", []) or []
    for external_id in external_ids:
        id_type = clean_text(external_id.get("external-id-type")).lower()
        id_value = clean_text(external_id.get("external-id-value"))
        if id_type and id_value:
            ids[id_type] = id_value
    return ids


def pick_work_summary(group: dict[str, Any]) -> dict[str, Any]:
    summaries = group.get("work-summary", []) or []
    if not summaries:
        return {}
    for summary in summaries:
        source_name = clean_text(((summary.get("source") or {}).get("source-name") or {}).get("value"))
        if source_name.upper() == "ORCID":
            return summary
    return summaries[0]


def record_from_orcid_summary(summary: dict[str, Any]) -> dict[str, Any]:
    title = clean_text(((summary.get("title") or {}).get("title") or {}).get("value"))
    ids = extract_external_ids(summary)
    doi = normalize_doi(ids.get("doi"))
    record_type = clean_text(summary.get("type"))
    url = clean_text((summary.get("url") or {}).get("value"))
    if doi and not url:
        url = f"https://doi.org/{doi}"
    return {
        "title": title,
        "authors": "",
        "venue": clean_text((summary.get("journal-title") or {}).get("value")),
        "date": orcid_date_to_iso(summary.get("publication-date")),
        "year": "",
        "doi": doi,
        "arxiv_id": ids.get("arxiv") or ids.get("arxiv-id") or "",
        "url": url,
        "type": record_type,
        "source": "ORCID",
        "section": section_for(record_type, "ORCID"),
    }


def enrich_with_crossref(record: dict[str, Any]) -> dict[str, Any]:
    doi = record.get("doi")
    if not doi:
        return record

    encoded_doi = urllib.parse.quote(doi, safe="")
    url = f"https://api.crossref.org/works/{encoded_doi}?mailto={urllib.parse.quote(CONTACT_EMAIL)}"
    try:
        data = fetch_json(url)
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return record
        raise

    message = data.get("message", {})
    titles = message.get("title") or []
    venues = message.get("container-title") or []
    authors = [format_author(author) for author in message.get("author", [])]
    date_parts = None
    for key in ("published-print", "published-online", "published", "issued"):
        if key in message:
            date_parts = (message[key].get("date-parts") or [[]])[0]
            break

    record["title"] = clean_text(titles[0] if titles else record.get("title"))
    record["authors"] = clean_text(", ".join(author for author in authors if author))
    record["venue"] = clean_text(venues[0] if venues else record.get("venue"))
    record["date"] = date_parts_to_iso(date_parts) or record.get("date", "")
    record["volume"] = clean_text(message.get("volume"))
    record["issue"] = clean_text(message.get("issue"))
    record["pages"] = clean_text(message.get("page"))
    record["type"] = clean_text(message.get("type")) or record.get("type", "")
    record["url"] = clean_text(message.get("URL")) or record.get("url", "")
    record["source"] = "Crossref"
    record["section"] = section_for(record.get("type", ""), "Crossref")
    return record


def fetch_orcid_records(orcid_id: str) -> list[dict[str, Any]]:
    url = f"https://pub.orcid.org/v3.0/{orcid_id}/works"
    data = fetch_json(url)
    records = []
    for group in data.get("group", []) or []:
        summary = pick_work_summary(group)
        if summary:
            records.append(record_from_orcid_summary(summary))
    return records


def fetch_arxiv_records(author: str) -> list[dict[str, Any]]:
    query = urllib.parse.quote(f'au:"{author}"')
    url = (
        "https://export.arxiv.org/api/query?"
        f"search_query={query}&start=0&max_results=50&sortBy=submittedDate&sortOrder=descending"
    )
    try:
        text = fetch_text(url)
    except (TimeoutError, urllib.error.URLError):
        return []

    root = ET.fromstring(text)
    ns = {"atom": "http://www.w3.org/2005/Atom", "arxiv": "http://arxiv.org/schemas/atom"}
    records = []
    for entry in root.findall("atom:entry", ns):
        title = clean_text(entry.findtext("atom:title", default="", namespaces=ns))
        authors = [
            clean_text(author_node.findtext("atom:name", default="", namespaces=ns))
            for author_node in entry.findall("atom:author", ns)
        ]
        arxiv_url = clean_text(entry.findtext("atom:id", default="", namespaces=ns))
        arxiv_id = arxiv_url.rsplit("/", 1)[-1] if arxiv_url else ""
        published = clean_text(entry.findtext("atom:published", default="", namespaces=ns))[:10]
        doi = clean_text(entry.findtext("arxiv:doi", default="", namespaces=ns))
        records.append(
            {
                "title": title,
                "authors": ", ".join(author for author in authors if author),
                "venue": "arXiv",
                "date": published,
                "year": published[:4],
                "doi": normalize_doi(doi),
                "arxiv_id": arxiv_id,
                "url": arxiv_url,
                "arxiv_url": arxiv_url,
                "type": "preprint",
                "source": "arXiv",
                "section": "preprints",
            }
        )
    return records


def finalize_record(record: dict[str, Any]) -> dict[str, Any]:
    date = clean_text(record.get("date"))
    record["date"] = date
    record["year"] = date[:4] if date else clean_text(record.get("year"))
    for key, value in list(record.items()):
        if isinstance(value, str):
            record[key] = clean_text(value)
    return record


def merge_records(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    merged = []
    seen_dois: set[str] = set()
    seen_titles: set[str] = set()
    by_doi: dict[str, dict[str, Any]] = {}
    by_title: dict[str, dict[str, Any]] = {}

    for record in records:
        record = finalize_record(record)
        title_key = normalize_title(record.get("title"))
        doi_key = normalize_doi(record.get("doi"))
        if doi_key and doi_key in seen_dois:
            merge_supplement(by_doi[doi_key], record)
            continue
        if title_key and title_key in seen_titles:
            merge_supplement(by_title[title_key], record)
            continue
        if doi_key:
            seen_dois.add(doi_key)
            by_doi[doi_key] = record
        if title_key:
            seen_titles.add(title_key)
            by_title[title_key] = record
        merged.append(record)

    return sorted(merged, key=lambda item: item.get("date") or "0000-00-00", reverse=True)


def merge_supplement(existing: dict[str, Any], supplement: dict[str, Any]) -> None:
    for key in ("label", "note", "order"):
        if supplement.get(key):
            existing[key] = supplement[key]
    for key in ("authors", "venue", "date", "year"):
        if not existing.get(key) and supplement.get(key):
            existing[key] = supplement[key]


def load_manual_records(path: Path) -> list[dict[str, Any]]:
    if not path.exists():
        return []
    return json.loads(path.read_text(encoding="utf-8"))


def update_publications(
    output: Path,
    orcid_id: str,
    arxiv_author: str,
    manual_file: Path,
) -> list[dict[str, Any]]:
    records = []
    for record in fetch_orcid_records(orcid_id):
        if record.get("doi"):
            time.sleep(0.25)
            record = enrich_with_crossref(record)
        records.append(record)
    for record in fetch_arxiv_records(arxiv_author):
        if record.get("doi"):
            time.sleep(0.25)
            record = enrich_with_crossref(record)
        records.append(record)
    records.extend(load_manual_records(manual_file))
    records = merge_records(records)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(records, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return records


def main() -> None:
    parser = argparse.ArgumentParser(description="Update publication data for the Jekyll site.")
    parser.add_argument("--output", default="_data/publications.json")
    parser.add_argument("--orcid", default=ORCID_ID)
    parser.add_argument("--arxiv-author", default=ARXIV_AUTHOR)
    parser.add_argument("--manual-file", default="_data/publications_manual.json")
    args = parser.parse_args()

    records = update_publications(
        Path(args.output),
        args.orcid,
        args.arxiv_author,
        Path(args.manual_file),
    )
    print(f"Updated {len(records)} publication records in {args.output}")


if __name__ == "__main__":
    main()
