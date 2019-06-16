<#include "../common/common.ftl">
package ${basePackage}.model;

import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;
import java.io.Serializable;
import javax.persistence.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * ${tableComment}
 * @author ${author}
 * @since ${currentTime}
 */
@Data
@Entity
@Table(name = "${tableName}")
@ApiModel("${tableComment}")
public class ${tableNamePojoNameMap[tableName]} implements Serializable{
	private static final long serialVersionUID = ${cnum?c};
<#if pksMap[tableName]?exists>
	<#list pksMap[tableName] as columnName>
		<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
	
	<#if columnCommentsMap[tableName + "|" + columnName]?exists>
	/**${columnCommentsMap[tableName + "|" + columnName]}*/
	</#if>
	@Id
	@Column(name = "${columnName}")
	//@GeneratedValue(strategy=GenerationType.IDENTITY)
	<#if columnCommentsMap[tableName + "|" + columnName]?exists>
	@ApiModelProperty(name = "${columnCommentsMap[tableName + "|" + columnName]}")
	<#else>
	@ApiModelProperty(name = "${columnJavaName}")
	</#if>
	private ${columnJavaType} ${columnJavaName};
	</#list>
	</#if>
	<#if unPkColumns?exists>
	<#list unPkColumns as columnName>
		<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
	
	<#if columnCommentsMap[tableName + "|" + columnName]?exists>
	/**${columnCommentsMap[tableName + "|" + columnName]}*/
	</#if>
	@Column(name = "${columnName}")
	<#if columnCommentsMap[tableName + "|" + columnName]?exists>
	@ApiModelProperty(name = "${columnCommentsMap[tableName + "|" + columnName]}")
	<#else>
	@ApiModelProperty(name = "${columnJavaName}")
	</#if>
	private ${columnJavaType} ${columnJavaName};
	</#list>
	</#if>
}