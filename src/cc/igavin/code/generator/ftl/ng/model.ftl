<#include "../common/common.ftl">
/**
 * ${tableComment}类
 * @author ${author}
 * @since ${currentTime}
 */
export class ${tableNamePojoNameMap[tableName]} {
	/**
     <#list columnNames as columnName>
		<#assign columnName2 = columnName />
		<#assign columnJavaType = columnJavaTypeMap[tableName + "|" + columnName] />
		<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
	* @param ${columnJavaName} <#if columnCommentsMap[tableName + "|" + columnName]?exists>${columnCommentsMap[tableName + "|" + columnName]}</#if>
	</#list>
	*/
	constructor (
       <#list columnNames as columnName>
		<#assign columnName2 = columnName />
		<#assign columnJavaType = columnJavaTypeMap[tableName + "|" + columnName] />
		<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
		<#assign columnNullable = columnNullableMap[tableName + "|" + columnName] />
		public ${columnJavaName}?:${columnJavaType}<#if columnName_has_next>,</#if>
	</#list>
	) {
	}
}
  
