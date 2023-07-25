import string
import xlrd

def Read_data_from_excel_file(filePath, sheetName):
    workbookObj = xlrd.open_workbook(filePath)
    sheet = workbookObj.sheet_by_name(sheetName)
    rowCount = sheet.nrows
    mydict ={}
    for i in range(0,rowCount):
        mydict.update({str(sheet.cell_value(i, 0)): str(sheet.cell_value(i, 1))})
    return mydict