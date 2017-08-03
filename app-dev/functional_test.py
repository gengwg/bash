from selenium import webdriver
import unittest

class AppApiTest(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()
        self.browser.implicitly_wait(3)

    def tearDown(self):
        self.browser.quit()

    def test_can_start_api(self):
        """Test ops api started by acessing a hello world page"""

        self.browser.get('http://localhost:60510/v1/hello_world')
        bodyText = self.browser.find_element_by_tag_name('body').text
        self.assertTrue("Hello" in bodyText)

if __name__=='__main__':
    #unittest.main(warnings='ignore')
    unittest.main()
