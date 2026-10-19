"""Check that approved citations survive automated publication imports."""

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "scripts"))
from update_publications import merge_records


class PublicationMergeTests(unittest.TestCase):
    def test_verified_issue_details_override_stale_import(self):
        records = merge_records([
            {"title": "SNR estimation", "doi": "10.1/snr", "date": "2024-01-01",
             "pages": "1-1", "source": "Crossref"},
            {"title": "SNR estimation", "doi": "10.1/snr", "date": "2025-01-01",
             "volume": "12", "issue": "1", "pages": "595-604",
             "source": "Manual", "override": True},
        ])
        self.assertEqual(len(records), 1)
        self.assertEqual(records[0]["date"], "2025-01-01")
        self.assertEqual(records[0]["year"], "2025")
        self.assertEqual(records[0]["pages"], "595-604")
        self.assertEqual(records[0]["volume"], "12")
        self.assertEqual(records[0]["issue"], "1")

    def test_published_paper_keeps_preprint_link_without_duplicate(self):
        records = merge_records([
            {"title": "Earlier cancer title", "doi": "10.48550/arxiv.1234",
             "date": "2026-03-11", "section": "other"},
            {"title": "Published disease title", "doi": "10.1/journal",
             "date": "2026-01-01", "section": "journal_articles"},
            {"title": "An unrelated paper", "doi": "10.1/other", "date": "2025-01-01"},
            {"title": "Published disease title", "doi": "10.1/journal",
             "date": "2026-09-11", "section": "journal_articles",
             "arxiv_id": "1234", "arxiv_url": "https://arxiv.org/abs/1234",
             "override": True, "replaces_titles": ["Earlier cancer title"]},
        ])
        self.assertEqual(len(records), 2)
        self.assertEqual(records[0]["title"], "Published disease title")
        self.assertEqual(records[0]["arxiv_url"], "https://arxiv.org/abs/1234")
        self.assertEqual(records[0]["section"], "journal_articles")
        self.assertEqual(records[1]["doi"], "10.1/other")

    def test_manual_numbering_preserves_imported_citation(self):
        records = merge_records([
            {"title": "A conference paper", "doi": "10.1/conference", "authors": "A. Author",
             "date": "2025-10-23", "venue": "Published proceedings"},
            {"title": "A conference paper", "authors": "", "venue": "", "date": "",
             "source": "Manual", "label": "C17", "order": 17},
        ])
        self.assertEqual(len(records), 1)
        self.assertEqual(records[0]["authors"], "A. Author")
        self.assertEqual(records[0]["venue"], "Published proceedings")
        self.assertEqual(records[0]["date"], "2025-10-23")
        self.assertEqual(records[0]["label"], "C17")


if __name__ == "__main__":
    unittest.main()
