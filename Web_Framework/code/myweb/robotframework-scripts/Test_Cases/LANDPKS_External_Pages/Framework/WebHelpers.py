'''
Created on Jul 8, 2016

@author: bbarnett
'''
from robot.api import logger
from robot.libraries import BuiltIn

def log_faster_map_export(iSecondsMap, iSecondsExport):
    iFasterBy = iSecondsMap-iSecondsExport if iSecondsMap > iSecondsExport else iSecondsExport-iSecondsMap
    if(iSecondsMap > iSecondsExport):
        msg = 'Pulling plot data from export is faster than filling the map with the same data by {0} seconds'.format(iFasterBy)
    else:
        msg = 'Filling map with plot data was faster than exporting the plot data by {0} seconds'.format(iFasterBy)
    logger.info(msg)
def select_pop_up_window():
    selenium = BuiltIn().get_library_instance('Selenium2Library')
    browser = selenium._current_browser()
    browser.switch_to_window(selenium.window_handles[1])
    