<!-- <#include "../common/common.ftl"> -->
<!-- ${tableComment}表单 -->
<!-- @author ${author} -->
<!-- @since ${currentTime}-->
<form class="form-horizontal" role="form" id="${tableNamePojoNameMap[tableName]}Form">
  <#list unPkColumns as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<div class="form-group">
    	<label for="${columnJavaName}" class="col-sm-3 control-label"><#if columnCommentsMap[tableName + "|" + columnName]?exists>${columnCommentsMap[tableName + "|" + columnName]}<#else>${columnJavaName}</#if>:</label>
    	<div class="col-sm-9">
      		<input type="text" class="form-control" id="${columnJavaName}" name="${columnJavaName}" placeholder="<#if columnCommentsMap[tableName + "|" + columnName]?exists>${columnCommentsMap[tableName + "|" + columnName]}<#else>${columnJavaName}</#if>"/>
    	</div>
  	</div>
	</#list>
</form>