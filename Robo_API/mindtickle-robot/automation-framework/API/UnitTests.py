from Utilities.CommonUtilities import *
import unittest
import os.path
import tempfile

tmpfilepath = os.path.join(tempfile.gettempdir(), "tmp-testfile")
filepath="C:\\Automation Branches\\Robo_API\\mindtickle-robot\\automation-framework\\API\Variables\\App_pods.xlsx"

class TestClass(unittest.TestCase):
	def test_Read_data_from_excel_file(self):
            my_dict=Read_data_from_excel_file(filepath, "env_1")
            assert type(my_dict) is dict
