package com.yihg.erp.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

/**
 * Excel组件
 * 
 * @author zhangxy
 * @version 1.0
 * @since 1.0
 */
public abstract class ExcelReporter {

	/**
	 * Excel 2003
	 */
	private final static String XLS = "xls";
	/**
	 * Excel 2007
	 */
	private final static String XLSX = "xlsx";

	/**
	 * 由Excel文件的Sheet导出至List
	 * 
	 * @param file
	 * @param sheetNum
	 * @return
	 */
	public static List<Map<String, String>> exportListFromExcel(
			String filePath, String businessType) throws Exception {
		if(StringUtils.isEmpty(filePath)){
			throw new Exception("文件路径不能不空");
		}
		if(StringUtils.isEmpty(businessType)){
			throw new Exception("业务类型不能不空");
		}		
		File file = new File(filePath);
		return exportListFromExcel(new FileInputStream(file),
				FilenameUtils.getExtension(file.getName()), businessType);
	}
	
	/**
	 * 
	 * @param filePath
	 * @param businessType
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, String>> exportListFromExcel(
			File file, String businessType) throws Exception {
		if(file==null){
			throw new Exception("文件不能不空");
		}
		if(StringUtils.isEmpty(businessType)){
			throw new Exception("业务类型不能不空");
		}	
		return exportListFromExcel(new FileInputStream(file),
				FilenameUtils.getExtension(file.getName()), businessType);
	}

	/**
	 * 由Excel流的Sheet导出至List
	 * 
	 * @param is
	 * @param extensionName
	 * @param sheetNum
	 * @return
	 * @throws IOException
	 */
	private static List<Map<String, String>> exportListFromExcel(InputStream is,
			String extensionName, String businessType) throws Exception {

		Workbook workbook = null;

		if (extensionName.toLowerCase().equals(XLS)) {
			workbook = new HSSFWorkbook(is);
		} else if (extensionName.toLowerCase().equals(XLSX)) {
			workbook = new XSSFWorkbook(is);
		}

		return exportListFromExcel(workbook, businessType);
	}

	/**
	 * 由指定的Sheet导出至List
	 * 
	 * @param workbook
	 * @param sheetNum
	 * @return
	 * @throws CloneNotSupportedException
	 * @throws IOException
	 */
	private static List<Map<String, String>> exportListFromExcel(
			Workbook workbook, String businessType) throws Exception {

		SAXReader reader = new SAXReader();
		Document document = null;
		try {
			//获取配置文件路径
			InputStream in = ExcelReporter.class.getResourceAsStream("/xlsReporterConfig.xml");
			if(in==null){
				throw new Exception("配置文件不存在");
			}
			 document = reader.read(in);
			//document = reader.read(new File("xlsReporterConfig.xml"));
		} catch (DocumentException e) {
			e.printStackTrace();
			return null;
		}
		Element rootElement = document.getRootElement();
		Element secondElement = rootElement.element(businessType);
		int sheetNum = Integer.parseInt(secondElement
				.attributeValue("sheetnum"));
		List nodes = secondElement.elements("col");
		int rowFrom = Integer.parseInt(secondElement.attributeValue("rowfrom"));
		Sheet sheet = workbook.getSheetAt(sheetNum);

		// 解析公式结果
		FormulaEvaluator evaluator = workbook.getCreationHelper()
				.createFormulaEvaluator();

		List<Map<String, String>> mapList = new ArrayList<Map<String, String>>();
		int minRowIx = sheet.getFirstRowNum() + 1;
		int maxRowIx = sheet.getLastRowNum();
		for (int rowIx = rowFrom; rowIx <= maxRowIx; rowIx++) {
			Map<String, String> map = new HashMap<String, String>();

			Row row = sheet.getRow(rowIx);
			int minColIx = row.getFirstCellNum();
			int maxColIx = row.getLastCellNum();
			for (int colIx = minColIx; colIx < maxColIx; colIx++) {
				Cell cell = row.getCell(colIx);
				boolean isMerged = isMergedRegion(sheet, rowIx, cell);
				for (Iterator it = nodes.iterator(); it.hasNext();) {
					Element elm = (Element) it.next();
					if (isMerged) {
						String mergedRegionValue = getMergedRegionValue(sheet,
								row.getRowNum(), cell.getColumnIndex());
						if (elm.attributeValue("colNum").equals("" + colIx)) {
							map.put(elm.attributeValue("name"),
									mergedRegionValue);
						} else {
							continue;
						}
					} else {
						String cellValue2 = getCellValue(cell);
						if (elm.attributeValue("colNum").equals("" + colIx)) {
							map.put(elm.attributeValue("name"), cellValue2);
						} else {
							continue;
						}
					}

					break;
				}
			}
			mapList.add(map);
		}
		return mapList;
	}

	private static String getMergedRegionValue(Sheet sheet, int row, int column) {
		// cell.setCellType(Cell.CELL_TYPE_STRING);
		// int column=cell.getColumnIndex();
		int sheetMergeCount = sheet.getNumMergedRegions();

		for (int i = 0; i < sheetMergeCount; i++) {
			CellRangeAddress ca = sheet.getMergedRegion(i);
			int firstColumn = ca.getFirstColumn();
			int lastColumn = ca.getLastColumn();
			int firstRow = ca.getFirstRow();
			int lastRow = ca.getLastRow();

			if (row >= firstRow && row <= lastRow) {

				if (column >= firstColumn && column <= lastColumn) {
					Row fRow = sheet.getRow(firstRow);
					Cell fCell = fRow.getCell(firstColumn);
					return getCellValue(fCell);
					// return fCell ;
					// return evaluator.evaluate(fCell);

				}
			}
		}

		return null;
	}

	// 获取单元格的值
	private static String getCellValue(Cell cell) {

		if (cell == null)
			return "";

		if (cell.getCellType() == Cell.CELL_TYPE_STRING) {

			return cell.getStringCellValue();

		} else if (cell.getCellType() == Cell.CELL_TYPE_BOOLEAN) {

			return String.valueOf(cell.getBooleanCellValue());

		} else if (cell.getCellType() == Cell.CELL_TYPE_FORMULA) {

			return cell.getCellFormula();

		} else if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
			if (DateUtil.isCellDateFormatted(cell)) {

				return new SimpleDateFormat("yyyy-MM-dd").format(DateUtil
						.getJavaDate(cell.getNumericCellValue()));
			} else {
				// cell.getNumberValue();
				return String.valueOf(cell.getNumericCellValue());
			}

		}
		return "";
	}

	/*
	 * private static boolean hasMerged(Sheet sheet) { return
	 * sheet.getNumMergedRegions() > 0 ? true : false; }
	 */

	private static boolean isMergedRegion(Sheet sheet, int row, Cell cell) {
		if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
			if (DateUtil.isCellDateFormatted(cell)) {
				cell.setCellType(Cell.CELL_TYPE_NUMERIC);
			}
		} else {

			cell.setCellType(Cell.CELL_TYPE_STRING);
		}
		int column = cell.getColumnIndex();
		int sheetMergeCount = sheet.getNumMergedRegions();
		for (int i = 0; i < sheetMergeCount; i++) {

			CellRangeAddress range = sheet.getMergedRegion(i);
			int firstColumn = range.getFirstColumn();
			int lastColumn = range.getLastColumn();
			int firstRow = range.getFirstRow();
			int lastRow = range.getLastRow();
			if (row >= firstRow && row <= lastRow) {
				if (column >= firstColumn && column <= lastColumn) {
					return true;
				}
			}
		}
		return false;
	}
}
