<!-- <#include "../common/common.ftl">-->
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!-- ${tableComment}管理页面 -->
<!-- @author ${author} -->
<!-- @since ${currentTime}-->
<script type="text/javascript">
	seajs.use(["base/sys","module/${tableNamePojoNameMap[tableName]}","base/easyTable"],function(sys,${tableNamePojoNameMap[tableName]},table){
		$(function(){
			${tableNamePojoNameMap[tableName]}.createTable($("#${tableNamePojoNameMap[tableName]}-table"));
		});
	});
</script>
<div class="panel-body" id="${tableNamePojoNameMap[tableName]}-table" style="height:100%;"></div>