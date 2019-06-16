<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--<#include "../common/common.ftl">-->
<!--
  ${tableComment} Mybatis Mapper
  @author ${author}
  @since ${currentTime}
-->
<mapper namespace="${basePackage}.mapper.${tableNamePojoNameMap[tableName]}">
	<resultMap type="${basePackage}.model.${tableNamePojoNameMap[tableName]}" id="${tableNamePojoNameMap[tableName]}Mapper">
	<#if pksMap[tableName]?exists>
	<#list pksMap[tableName] as columnName>
		<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
		<#assign columnDBType=columnDBTypeMap[tableName + "|" + columnName] />
		<id property="${columnJavaName}" column="${columnName}"<#-- javaType="${columnJavaType}" jdbcType="${columnDBType}-->"/>
	</#list>
	</#if>
	<#if unPkColumns?exists>
	<#list unPkColumns as columnName>
		<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
		<#assign columnDBType=columnDBTypeMap[tableName + "|" + columnName] />
		<result property="${columnJavaName}" column="${columnName}"<#-- javaType="${columnJavaType}" jdbcType="${columnDBType}-->"/>
	</#list>
	</#if>
	</resultMap>
	
	<insert id="insert" parameterType="${basePackage}.model.${tableNamePojoNameMap[tableName]}">
		<#assign sql="insert into " + tableName + "(" />
		<#list columnNames as columnName>
			<#assign sql=sql + columnName + "," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1) + ")  values(" />
		<#list columnNames as columnName>
			<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			<#assign sql=sql+"#\{"+columnJavaName + "}," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1) + ")" />
		${sql}
	</insert>
	<#if pksMap[tableName]?exists>
	
	<update id="update" parameterType="${basePackage}.model.${tableNamePojoNameMap[tableName]}">
		<#assign sql="update "+tableName+" set "/>
		<#list unPkColumns as columnName>
			<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			<#assign sql=sql + columnName + "=#\{"+columnJavaName+"}," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1)/>
		<#assign sql=sql +" where " />
		<#list pksMap[tableName] as columnName>
			<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			<#assign sql=sql + columnName + "=#\{"+columnJavaName+"}," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1) + ")" />
		${sql}
	</update>
	
	<delete id="delete" parameterType="java.util.HashMap">
        <#assign sql="delete from " + tableName + " where " />
		<#list pksMap[tableName] as columnName>
			<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			<#assign sql=sql + columnName + "=#\{"+columnJavaName+"}," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1) + ")" />
		${sql}
    </delete>
    
    <select id="query" parameterType="java.util.HashMap" resultMap="${tableNamePojoNameMap[tableName]}Mapper">
		<#assign sql="select "/>
		<#list columnNames as columnName>
			<#assign sql=sql + columnName +"," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1)/>
		<#assign sql=sql +" from "+tableName+" where " />
		<#list pksMap[tableName] as columnName>
			<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			<#assign sql=sql + columnName + "=#\{"+columnJavaName+"}," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1) + ")" />
		${sql}
	</select>
	</#if>
	
	<select id="queryAll" resultType="${basePackage}.model.${tableNamePojoNameMap[tableName]}">
		<#assign sql="select "/>
		<#list columnNames as columnName>
			<#assign sql=sql + columnName +"," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1)/>
		<#assign sql=sql +" from "+tableName/>
		${sql}
	</select>
	
	<select id="page" resultType="${basePackage}.model.${tableNamePojoNameMap[tableName]}">
		<#assign sql="select "/>
		<#list columnNames as columnName>
			<#assign sql=sql + columnName +"," />
		</#list>
		<#assign sql=sql?substring(0, sql?length - 1)/>
		<#assign sql=sql +" from "+tableName/>
		${sql}
	</select>
</mapper>