"""
Sample test
"""


from django.test import SimpleTestCase
from app import calc


class CalcTests(SimpleTestCase):
    """Tes the calc module"""

    def test_add_numbers(self):
        """Test adding numbers tohether."""
        res = calc.add(3, 8)

        self.assertEqual(res, 11)

    def test_substrac_numbers(self):
        "test substracting numbers."
        res = calc.substract(5, 11)

        self.assertEqual(res, 6)
