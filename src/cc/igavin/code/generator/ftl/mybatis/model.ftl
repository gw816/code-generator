<#include "../common/common.ftl">
package ${basePackage}.model;

import lombok.Data;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.io.Serializable;
import org.springframework.jdbc.core.RowMapper;
import cc.igavin.jdbc.StandardModel;

/**
 * ${tableComment}实体类
 * @author ${author}
 * @since ${currentTime}
 */
@Data
public class ${tableNamePojoNameMap[tableName]} implements StandardModel<${tableNamePojoNameMap[tableName]}>{
	private static final long serialVersionUID = ${cnum?c};
<#list columnNames as columnName>
	<#assign columnName2 = columnName />
	<#assign columnJavaType = columnJavaTypeMap[tableName + "|" + columnName] />
	<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
	<#assign columnNullable = columnNullableMap[tableName + "|" + columnName] />
	<#if columnCommentsMap[tableName + "|" + columnName]?exists>//${columnCommentsMap[tableName + "|" + columnName]}</#if>
	private ${columnJavaType} ${columnJavaName};
</#list>


	/**
	* 重写RowMappper的mapRow方法
	* @return ${tableNamePojoNameMap[tableName]}
	*/
	public ${tableNamePojoNameMap[tableName]} mapRow(ResultSet rs, int rowNum) throws SQLException {
		${tableNamePojoNameMap[tableName]} m = new ${tableNamePojoNameMap[tableName]}();
<#list columnNames as columnName>
	<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		m.set${columnJavaName?cap_first}(rs.get<#if (columnJavaType?cap_first)="Byte[]">Bytes<#elseif (columnJavaType?cap_first)="Date">Timestamp<#else>${columnJavaType?cap_first}</#if>("${columnName}"));
</#list>
		return m;
	}
	
	/**
	* 转换成map，并且是有序排列的LinkedHashMap
	* @return Map<String, Object>
	*/
	public Map<String, Object> toMap() {
		Map<String, Object> m = new LinkedHashMap<String, Object>();
<#list columnNames as columnName>
	<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		m.put("${columnJavaName}", get${columnJavaName?cap_first}());
</#list>
		return m;
	}


	/**
	* 获取主键Map
	* @return Map<String, Object>
	*/
	public Map<String, Object> pksMap() {
<#if pksMap[tableName]?exists>
		Map<String, Object> m = new HashMap<String, Object>();
<#list pksMap[tableName] as columnName>
	<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		m.put("${columnJavaName}", get${columnJavaName?cap_first}());
</#list>
		return m;
<#else>
		return null;		
</#if>
	}

	/**
	 * 根据属性名换取对应数据库字段名
	 * @param attribute
	 * @return
	 */
	public String getFieldName(String attribute){
		if(null == attribute){
			return null;
		}else{
			switch (attribute) {
			<#list columnNames as columnName>
				<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
				case "${columnJavaName}":return "${columnName}";
			</#list>
				default:return null;
			}
		}
	}
}