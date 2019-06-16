package cc.igavin.code.generator.impl;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import cc.igavin.code.generator.util.Logger;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cc.igavin.code.generator.interfaces.Gen;
import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

public class GenMySQL extends Gen {

	public GenMySQL(Properties properties) throws Exception {
		this.prepare(properties);
	}

	protected void initDs() throws Exception {
		MysqlDataSource myDs = new MysqlDataSource();
		myDs.setUrl(this.properties.getProperty("mysql.url"));
		myDs.setUser(this.properties.getProperty("mysql.username"));
		myDs.setPassword(this.properties.getProperty("mysql.password"));
		this.ds = myDs;
		this.qr = new QueryRunner(this.ds);
	}

	protected void getTables() throws Exception {
		String sql = "";
		sql += "SELECT a.TABLE_NAME AS \"TABLE_NAME\",a.TABLE_COMMENT AS \"TABLE_COMMENT\" ";
		sql += "FROM information_schema.TABLES a ";
		sql += "WHERE LOWER(a.TABLE_SCHEMA) = '" + this.databaseName.toLowerCase() + "'";

		List<Map<String, Object>> dataList = this.qr.query(sql, new MapListHandler());
		if (dataList == null || dataList.size() == 0) {
			return;
		}

		List<Map<String, Object>> dataList2 = null;
		if (isIncludeView()) {
			String sql2 = "SELECT a.TABLE_NAME AS TABLE_NAME FROM information_schema.VIEWS a WHERE LOWER(a.TABLE_SCHEMA) = '"
					+ this.databaseName.toLowerCase() + "'";
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
		sql += "SELECT a.TABLE_NAME as \"TABLE_NAME\", GROUP_CONCAT(a.COLUMN_NAME) AS \"PKS\" ";
		sql += "FROM information_schema.columns a  ";
		sql += "WHERE 1 = 1 ";
		sql += "AND LOWER(a.TABLE_SCHEMA) = '" + this.databaseName.toLowerCase() + "' ";
		sql += "AND LOWER(a.COLUMN_KEY) = 'pri' ";
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

			// 鍒楀悕澶у皬鍐欒浆鎹�
			String tmp = "";
			for (int i = 0; i < pks.length; i++) {
				pks[i] = (this.sqlCase.equals("upper") ? pks[i].toUpperCase() : pks[i].toLowerCase());
				tmp += pks[i] + ",";
			}

			this.pksMap.put(tableName, pks);
			Logger.info(tableName + "--pks-->" + tmp);
		}
	}

	protected void getColumnsInfo() throws Exception {
		for (String tableName : this.tablesNames) {
			String sql = "SELECT * " + "FROM information_schema.COLUMNS " + "where LOWER(TABLE_SCHEMA) = '"
					+ this.databaseName.toLowerCase() + "' " + "and LOWER(TABLE_NAME) = '" + tableName.toLowerCase()
					+ "' " + "ORDER BY ORDINAL_POSITION ASC";
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
		String javaType = null;
		String databaseType = null;

		Logger.info(Logger.PRE_LONG + "getColumnJavaType()");
		Logger.info("tableName,columnName,databaseType,javaType");
		Logger.info(Logger.PRE_MID);

		for (Entry<String, Map<String, Object>> entry : this.columnInfoMap.entrySet()) {
			String columnName = entry.getKey();

			databaseType = entry.getValue().get("DATA_TYPE").toString().toUpperCase();
			javaType = this.refMap.get(databaseType);
			Logger.info(columnName + "," + databaseType + "," + javaType);

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

			nullableStr = entry.getValue().get("IS_NULLABLE").toString().toUpperCase();
			if (nullableStr.equals("YES")) {
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
			commentsObj = entry.getValue().get("COLUMN_COMMENT");
			String comments = null;
			if (commentsObj != null && !commentsObj.equals("")) {
				comments = commentsObj.toString();
				this.columnCommentsMap.put(columnName, comments);
			}
			Logger.info(columnName + "," + comments);

		}
	}
}
