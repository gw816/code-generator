package cc.igavin.code.generator.impl;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import cc.igavin.code.generator.util.Logger;
import oracle.jdbc.pool.OracleDataSource;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cc.igavin.code.generator.interfaces.Gen;

public class GenOracle extends Gen {

	public GenOracle(Properties properties) throws Exception {
		this.prepare(properties);
	}

	protected void initDs() throws Exception {
		OracleDataSource oraDs = new OracleDataSource();
		oraDs.setURL(this.properties.getProperty("oracle.url"));
		oraDs.setUser(this.properties.getProperty("oracle.username"));
		oraDs.setPassword(this.properties.getProperty("oracle.password"));
		this.ds = oraDs;
		this.qr = new QueryRunner(this.ds);
	}

	protected void getTables() throws Exception {
		String sql = "select t.table_name as TABLE_NAME,f.comments as TABLE_COMMENT from user_tables t inner join user_tab_comments f on t.table_name = f.table_name";

		List<Map<String, Object>> dataList = this.qr.query(sql, new MapListHandler());
		if (dataList == null || dataList.size() == 0) {
			return;
		}
		List<Map<String, Object>> dataList2 = null;
		if (isIncludeView()) {
			String sql2 = "select t.VIEW_NAME as TABLE_NAME,f.comments as TABLE_COMMENT from User_Views t inner join user_tab_comments f on t.VIEW_NAME = f.table_name";
			dataList2 = this.qr.query(sql2, new MapListHandler());
		}
		if (dataList2 != null && dataList2.size() > 0) {
			dataList.addAll(dataList2);
		}

		this.tablesNames = new String[dataList.size()];

		String tname = null;
		Object tcomments = null;
		Logger.info(Logger.PRE_LONG + "getTables()");
		for (int i = 0; i < dataList.size(); i++) {
			tname = dataList.get(i).get("TABLE_NAME").toString();
			tcomments = dataList.get(i).get("TABLE_COMMENT");
			tname = this.sqlCase.equals("upper") ? tname.toUpperCase() : tname.toLowerCase();
			this.tablesNames[i] = tname;
			this.tableNameCommentsMap.put(tname, tcomments == null ? null : tcomments.toString());
			Logger.info("tableName:" + this.tablesNames[i]);
		}
	}

	protected void getPKs() throws Exception {
		String sql = "";
		sql += "SELECT a.TABLE_NAME AS \"TABLE_NAME\", wm_concat(a.column_name) AS \"PKS\" ";
		sql += "FROM user_cons_columns a ";
		sql += "INNER JOIN user_constraints b ON a.constraint_name = b.constraint_name ";
		sql += "WHERE 1 = 1 ";
		sql += "AND b.constraint_type = 'P'";
		sql += "AND INSTR(a.table_name, 'BIN$') = 0 ";
		sql += "AND UPPER(a.owner) = '" + this.databaseName.toUpperCase() + "' ";
		sql += "GROUP BY a.TABLE_NAME ";
		List<Map<String, Object>> dataList = qr.query(sql, new MapListHandler());

		if (dataList == null || dataList.size() == 0) {
			Logger.info("[WARNING],no pk was found");
			return;
		}

		String tableName = null;
		String pksStr = null;
		String[] pks = null;
		Logger.info(Logger.PRE_LONG + "getPKs()");
		for (Map<String, Object> item : dataList) {
			tableName = item.get("TABLE_NAME").toString();
			tableName = this.sqlCase.equals("upper") ? tableName.toUpperCase() : tableName.toLowerCase();
			pksStr = item.get("PKS").toString();
			pks = pksStr.split(",");

			// 列名大小写转换
			String tmp = "";
			for (int i = 0; i < pks.length; i++) {
				pks[i] = (this.sqlCase.equals("upper") ? pks[i].toUpperCase() : pks[i].toLowerCase());

				// will print this string
				tmp += pks[i];
				if (i != pks.length - 1) {
					tmp += ",";
				}
			}

			this.pksMap.put(tableName, pks);
			Logger.info(tableName + "--pks-->" + tmp);
		}
	}

	protected void getColumnsInfo() throws Exception {
		for (String tableName : this.tablesNames) {
			String sql = "select  A.column_name COLUMN_NAME,A.data_type DATA_TYPE,"
					+ "A.data_length DATA_LENGTH,A.data_precision DATA_PRECISION,"
					+ "A.DATA_SCALE DATA_SCALE,A.nullable NULLABLE,A.Data_default DATA_DEFAULT,"
					+ "B.comments COMMENTS from user_tab_columns A,user_col_comments B "
					+ "where A.Table_Name = B.Table_Name and A.Column_Name = B.Column_Name " + "and A.Table_Name = '"
					+ tableName.toUpperCase() + "' ORDER BY A.COLUMN_ID ASC";
			List<Map<String, Object>> dataList = qr.query(sql, new MapListHandler());

			String key = null;
			String columnName = null;
			for (Map<String, Object> columnInfo : dataList) {
				columnName = columnInfo.get("COLUMN_NAME").toString();
				columnName = this.sqlCase.equals("upper") ? columnName.toUpperCase() : columnName.toLowerCase();

				key = tableName + "|" + columnName;
				this.columnInfoMap.put(key, columnInfo);
			}
		}
	}

	protected void getColumnJavaType() throws Exception {
		String columnName = null;
		String javaType = null;
		String databaseType = null;
		Object dataScale = null;

		Logger.info(Logger.PRE_LONG + "getColumnJavaType()");
		Logger.info("tableName,columnName,databaseType,dataScale,javaType");
		Logger.info(Logger.PRE_MID);

		for (Entry<String, Map<String, Object>> entry : this.columnInfoMap.entrySet()) {
			columnName = entry.getKey();

			dataScale = entry.getValue().get("DATA_SCALE");
			databaseType = entry.getValue().get("DATA_TYPE").toString().toUpperCase();
			if (dataScale == null || dataScale.toString().equals("")) {
				javaType = this.refMap.get(databaseType);
				dataScale = "";
			} else {
				javaType = this.refMap.get("DATA_SCALE");
			}
			Logger.info(columnName + "," + databaseType + "," + dataScale + "," + javaType);

			this.columnJavaTypeMap.put(columnName, javaType);
			this.columnDBTypeMap.put(columnName, databaseType);
		}
	}

	@Override
	protected void getColumnNullable() throws Exception {
		String columnName = null;
		String nullableStr = null;
		boolean nullable = false;
		Logger.info(Logger.PRE_LONG + "getColumnNullableMap()");
		Logger.info("tableName|columnName,nullbale");
		Logger.info(Logger.PRE_MID);

		for (Entry<String, Map<String, Object>> entry : this.columnInfoMap.entrySet()) {
			columnName = entry.getKey();

			nullableStr = entry.getValue().get("NULLABLE").toString().toUpperCase();
			if (nullableStr.equals("Y")) {
				nullable = true;
			}
			this.columnNullableMap.put(columnName, nullable);
			Logger.info(columnName + "," + nullable);

		}
	}

	@Override
	protected void getColumnComments() throws Exception {
		String columnName = null;
		Object commentsObj = null;
		Logger.info(Logger.PRE_LONG + "getColumnCommentsMap()");
		Logger.info("tableName|columnName,comments");
		Logger.info(Logger.PRE_MID);

		for (Entry<String, Map<String, Object>> entry : this.columnInfoMap.entrySet()) {
			columnName = entry.getKey();
			commentsObj = entry.getValue().get("COMMENTS");
			String comments = null;
			if (commentsObj != null && !commentsObj.equals("")) {
				comments = commentsObj.toString();
				this.columnCommentsMap.put(columnName, comments);
			}
			Logger.info(columnName + "," + comments);

		}
	}
}
