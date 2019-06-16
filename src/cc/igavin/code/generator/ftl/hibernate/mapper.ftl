<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//ibatis.apache.org//DTD Mapper 3.0//EN" "http://ibatis.apache.org/dtd/ibatis-3-mapper.dtd">
<#include "../common/common.ftl">
<!--
  ${tableComment} Hibernate Mapper
  Hibernate版是个半成品，有需要的话联系做选配
  @author ${author}
  @since ${currentTime}
-->
<mapper namespace="">
<#assign pojoName = tableNamePojoNameMap[tableName] />
<#assign modelPackage =  basePackage+".model"/>
<#assign pojoCanonicalName = modelPackage + "." + pojoName />

	<!#-- 生成Insert -->
	<insert id="${pojoName}.Insert" parameterType="${pojoCanonicalName}">
		insert into ${tableName} (
			<trim suffixOverrides=",">
				<#list columnNames as columnName>
					<#assign columnJavaType = columnJavaTypeMap[tableName + "|" + columnName] />
					<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
					<if test="${columnJavaName} != null and ${columnJavaName} != ''">${columnName},</if>
				</#list>
			</trim>
		) values (
			<trim suffixOverrides=",">
				<#list columnNames as columnName>
					<#assign columnJavaType = columnJavaTypeMap[tableName + "|" + columnName] />
					<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
					<if test="${columnJavaName} != null and ${columnJavaName} != ''">${r"#{"}${columnJavaName}${r"}"},</if>
				</#list>
			</trim>
		)
	</insert>
	
	<!#-- 生成Update -->
	<update id="${pojoName}.Update" parameterType="${pojoCanonicalName}">
		update ${tableName} set 
		<trim suffixOverrides=",">
			<#list columnNames as columnName>
				<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
				${columnName} = #${r"{"}${columnJavaName}${r"}"},
			</#list>
		</trim>
	</update>
	
	<!#-- 根据表的主键生成Delete -->
	<#if pksMap[tableName]??><#-- 该表有主键 -->
		<#if (pksMap[tableName]?size == 1)><#-- 该表有主键，且是单列主键 -->
			<#assign parameterType = "java.io.Serializable" />
		<#elseif (pksMap[tableName]?size > 1)><#-- 该表有主键，且是联合主键 -->
			<#assign parameterType = modelPackage + "." + tableName?cap_first />
		</#if>
		<delete id="${pojoName}.DeleteByPk" parameterType="${parameterType}">
			<#if (pksMap[tableName]?size > 1)><!-- 请注意，该表是联合主键 --></#if>
			delete 
			from ${tableName} 
			where 
			<#list pksMap[tableName] as columnName>
				<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
				${columnName} = #${r"{"}${columnJavaName}${r"}"}
				<#if columnName_has_next>and</#if>
			</#list>
		</delete>
	<#else><#-- 该表无主键 -->
		<delete id="${pojoName}.DeleteByPojo" parameterType="${pojoCanonicalName}">
			<!-- 请注意，该表没有主键 -->
			delete 
			from ${tableName} 
			where
			<#list columnNames as columnName>
				<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
				${columnName} = #${r"{"}${columnJavaName}${r"}"}
				<#if columnName_has_next>and</#if>
			</#list>
		</delete>
	</#if>
	
	<!#-- 生成Select通用表头 -->
	<sql id="${pojoName}.Select.Columns">
		<trim suffixOverrides=",">
			<#list columnNames as columnName>
				<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
				${columnName} as "${columnJavaName}",
			</#list>
		</trim>
	</sql>
	
	<!#-- 生成Select通用查询条件 -->
	<sql id="${pojoName}.Select.Wheres">
		<#list columnNames as columnName>
			<#assign columnJavaName = columnJavaNameMap[tableName + "|" + columnName] />
			<if test="${columnJavaName} != null and ${columnJavaName} != ''">
				and ${columnName} = ${r"{"}#${columnJavaName}${r"}"}
			</if>
		</#list>
	</sql>
	
	<!#-- 生成Select -->
	<select id="${pojoName}.Select" parameterType="${pojoCanonicalName}" resultType="${pojoCanonicalName}">
		select
		<include refid="${tableName?cap_first}.Select.Columns"/>
		from ${tableName}
		where 1 = 1
		<include refid="${tableName?cap_first}.Select.Wheres"/>
	</select>
</mapper>