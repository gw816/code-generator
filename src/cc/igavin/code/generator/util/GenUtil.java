package cc.igavin.code.generator.util;

/**
 * 代码生成工具，数据库表信息与java规范名称转换工具
 * @author Gavin
 */
public class GenUtil {
	public static String characterFilter[];
	// 将数据库的表名，转换为JavaBean名
	public static String TableNameToPojoName(String tableName, boolean toJavaName) {
		tableName=ExcuteCharacterFilter(tableName);
		if (toJavaName) {
			tableName = ColumnNameToJavaPropertyName(tableName);
		}
		tableName = lowerSecondKeepOthers(tableName);
		tableName = UpperFirstKeepOthers(tableName);
		return tableName;
	}

	// 将数据库字段名转换为JavaBean名
	public static String ColumnNameToPojoName(String columnName, boolean toJavaName) {
		columnName=ExcuteCharacterFilter(columnName);
		if (toJavaName) {
			columnName = ColumnNameToJavaPropertyName(columnName);
		}
		columnName = lowerSecondKeepOthers(columnName);
		return columnName;
	}

	private static String ExcuteCharacterFilter(String name){
		if(null != characterFilter && characterFilter.length>0){
			for(String filter:characterFilter){
				if(name.startsWith(filter)){
					name=name.substring(filter.length());
				}
				if(name.endsWith(filter)){
					name=name.substring(0,name.length()-filter.length());
				}
			}
		}
		return name;
	}
	private static String lowerSecondKeepOthers(String str) {
		if (str.length() > 2) {
			char second = str.charAt(1);
			if (second < 91 && second > 64) {
				str = str.charAt(0) + (second + "").toLowerCase() + str.substring(2);
			}
		}
		return str;
	}

	// 将表的字段名，转换为JavaBean属性名
	private static String ColumnNameToJavaPropertyName(String columnName) {
		// 将任意的空白符用空字符串替换
		columnName = columnName.replaceAll("\\s", "");
		columnName = columnName.toLowerCase();
		String[] segs = columnName.split("_");
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < segs.length; i++) {
			if (i == 0) {
				sb.append(segs[i]);
			} else {
				sb.append(UpperFirstLowerOthers(segs[i]));
			}
		}
		return sb.toString();
	}

	// 首字母大写，其它字符保持不变
	private static String UpperFirstKeepOthers(String str) {
		if(null == str || str.length()==0){
			return str;
		}else if (str.length() == 1) {
			return str.toUpperCase();
		}

		str = str.substring(0, 1).toUpperCase() + str.substring(1);
		return str;
	}

	// 首字母大写，其它字符转换成小写
	public static String UpperFirstLowerOthers(String str) {
		if(null == str || str.length()==0){
			return str;
		}else if (str.length() == 1) {
			return str.toUpperCase();
		}

		str = str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
		return str;
	}
}
