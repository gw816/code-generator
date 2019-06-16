<#include "../common/common.ftl">
/**
 * ${tableComment}管理模块
 * @author ${author}
 * @since ${currentTime}
 */
define(function(require,exports,module){
	var sys = require("base/sys");
	var easyTable = require("base/easyTable");
	var pagination = require("base/pagePagination");
	/**
	 *  根据主键id获取${tableComment}
	 *  @param params id
	 */
	function get${tableNamePojoNameMap[tableName]}(id){
		var sReturn = null;
		sys.operateData({id:id},"${tableNamePojoNameMap[tableName]}Controller/query${tableNamePojoNameMap[tableName]}",function(data){
			sReturn=data;
		},false);
		return sReturn;
	}
	exports.get${tableNamePojoNameMap[tableName]} = get${tableNamePojoNameMap[tableName]};
	
	/**
	 *  添加${tableComment}
	 *  @param params ${tableComment}
	 */
	function add${tableNamePojoNameMap[tableName]}(params){
		var sReturn = null;
		sys.operateData(params,"${tableNamePojoNameMap[tableName]}Controller/add${tableNamePojoNameMap[tableName]}",function(data){
			sReturn = data;
		},false);
		return sReturn;
	}
	exports.add${tableNamePojoNameMap[tableName]} = add${tableNamePojoNameMap[tableName]};
	
	/**
	 *  更新${tableComment}
	 *  @param params ${tableComment}
	 */
	function update${tableNamePojoNameMap[tableName]}(params){
		var sReturn = null;
		sys.operateData(params,"${tableNamePojoNameMap[tableName]}Controller/update${tableNamePojoNameMap[tableName]}",function(data){
			sReturn = data;
		},false);
		return sReturn;
	}
	exports.update${tableNamePojoNameMap[tableName]} = update${tableNamePojoNameMap[tableName]};
	
	/**
	 *  批量删除${tableComment}
	 *  @param ids 主键id数组
	 */
	function deleteBatch${tableNamePojoNameMap[tableName]}(ids){
		var sReturn = null;
		sys.operateData(ids,"${tableNamePojoNameMap[tableName]}Controller/deleteBatch${tableNamePojoNameMap[tableName]}",function(data){
			sReturn = data;
		},false);
		return sReturn;
	}
	exports.deleteBatch${tableNamePojoNameMap[tableName]} = deleteBatch${tableNamePojoNameMap[tableName]};
	
	/**
	 * 按条件获取${tableComment}列表
	 * @param params 条件信息。比如要查cUnit为essence的所有数据，那{cUnit:essence}
	 * 			map为null或者未传参是代表查询所有
	 */
	function get${tableNamePojoNameMap[tableName]}List(params){
		var inParams=null;
		if(undefined!=params){
			inParams=params;
		}
		var sReturn = null;
		if(inParams==null){
			sys.operateData(null,"${tableNamePojoNameMap[tableName]}Controller/get${tableNamePojoNameMap[tableName]}List",function(data){
				sReturn=data;
			},false);
		}else{
			sys.operateData(inParams,"${tableNamePojoNameMap[tableName]}Controller/get${tableNamePojoNameMap[tableName]}ListByCondition",function(data){
				sReturn=data;
			},false);
		}
		return sReturn;
	}
	exports.get${tableNamePojoNameMap[tableName]}List = get${tableNamePojoNameMap[tableName]}List;
	
	/**
	 * 弹出一个${tableComment}信息页面
	 * @param ${tableNamePojoNameMap[tableName]} 要展示的数据对象。提示，可以通过get${tableNamePojoNameMap[tableName]}方法或取，也可以通过表格插件获取。
	 */
	function show${tableNamePojoNameMap[tableName]}(${tableNamePojoNameMap[tableName]}){
		var show${tableNamePojoNameMap[tableName]}Win = null;
		show${tableNamePojoNameMap[tableName]}Win = sys.sysDialog({
			title:"${tableComment}",
			url:basePath + "app/baseData/${tableNamePojoNameMap[tableName]}.html",
			width:"600px",
			open:function  (win) {
				<#list unPkColumns as columnName>
				<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
				show${tableNamePojoNameMap[tableName]}Win.find("input[name='${columnJavaName}']").val(${tableNamePojoNameMap[tableName]}.${columnJavaName});
				</#list>
				show${tableNamePojoNameMap[tableName]}Win.find("input").attr("disabled",true);
			},
			buttons:[{
				text:"关闭",
				className:"btn-primary",
				click:function  () {
					show${tableNamePojoNameMap[tableName]}Win.close();
				}
			}]
		});
	}
	exports.show${tableNamePojoNameMap[tableName]} = show${tableNamePojoNameMap[tableName]};
	
	function createTable(selector){
		selector.empty();
		var ${tableNamePojoNameMap[tableName]}Table=easyTable.easyTable({
			selector:selector,//容器选择器
			serverUrl:"${tableNamePojoNameMap[tableName]}Controller/get${tableNamePojoNameMap[tableName]}Page",//初始化路径
			serverParam : {
				eachRecords : 10,             // 每页显示条数
				showPage : 1,                 // 当前是第几页
				conditions : {                // 特殊的条件
					order : null,            // 多列排序的对象数组
					like_string : null,      // 多列搜索的对象数组
					in_string : null,        // 字符串对象
					in_int : null,           // 数字对象
					where_int : null,        // 数字相等
					where_string : null     // 字符串相等
				},
			},
			toolBar:true,
			toolBarWidth:"col-md-4",
			toolBarButtons:[
			{
				text:"导入",
				btnClass:"btn-primary",
				click:function(){
					var importData=sys.sysDialog({
						width:500,
						url:"app/baseData/uploadFile.html",
						title:"文件上传",
						buttons:[{
							text:"上传",
							click:function(){
								if($("#upload_file").val() == ""){
									sys.sysAlert("请选择上传文件！");
								}else{
									$.gavinUpload({
										url:basePath+"${tableNamePojoNameMap[tableName]}Controller/importData",
										fileElementId:["upload_file"],
										secureuri:false,
										dataType: 'json',
										success: function (data){
											if(data>0){
												createTable(selector);
											}else{
												sys.sysAlert("导入失败，请重试！");
											}
										}
									}); 
									importData.close();
								}
							}
						},{
							text:"取消",
							click:function(){
								importData.close();
							}
						}],
						open:function(win){
							$.renderUpload();
						}
					});
				}
			},{
				text:"导出",
				btnClass:"btn-primary",
				click:function(){
					window.open(basePath+"${tableNamePojoNameMap[tableName]}Controller/exportData");
				}
			},{
				text:"添加",
				btnClass:"btn-primary",
				click:function(){
					var dialogwin = null;
					dialogwin = sys.sysDialog({
						title:"添加${tableComment}",
						url:basePath + "app/baseData/${tableNamePojoNameMap[tableName]}.html",
						width:"600px",
						open:function  (win) {
						},
						buttons:[{
							text:"确定",
							className:"btn-primary",
							click:function  () {
								var params = sys.getFormObj($("#${tableNamePojoNameMap[tableName]}Form"));
								sys.operateData(params,"${tableNamePojoNameMap[tableName]}Controller/add${tableNamePojoNameMap[tableName]}",function(data){
									if(data>0){
										createTable(selector);
									}else{
										sys.sysAlert("添加失败，请重试！");
									}
								},false);
								dialogwin.close();
							}
						},{
							text:"取消",
							className:"btn-primary",
							click:function  () {
								dialogwin.close();
							}
						}]
					});
				}
			}<#if pksMap[tableName]?exists>,{
				text:"更新",
				btnClass:"btn-primary",
				click:function(){
					var dialogwin = null;
					var selectedTR = ${tableNamePojoNameMap[tableName]}Table.getSelected();
					if(selectedTR==null){
						sys.sysAlert("请选择一条数据进行编辑！");
					}else{
						dialogwin = sys.sysDialog({
							title:"更新${tableComment}",
							url:basePath + "app/baseData/${tableNamePojoNameMap[tableName]}.html",
							width:"600px",
							open:function  (win) {
							<#list unPkColumns as columnName>
							<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
								dialogwin.find("input[name='${columnJavaName}']").val(selectedTR.${columnJavaName});
							</#list>
							},
							buttons:[{
								text:"确定",
								className:"btn-primary",
								click:function  () {
									var params = sys.getFormObj($("#${tableNamePojoNameMap[tableName]}Form"));
									<#list pksMap[tableName] as columnName>
									<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
									params["${columnJavaName}"]=selectedTR.${columnJavaName};
									</#list>
									var data=update${tableNamePojoNameMap[tableName]}(params);
									if(data>0){
										createTable(selector);
										dialogwin.close();
									}else{
										sys.sysAlert("更新失败，请重试！");
									}
								}
							},{
								text:"取消",
								className:"btn-primary",
								click:function  () {
									dialogwin.close();
								}
							}]
						});
					}
				}
			},{
				text:"删除",
				btnClass:"btn-primary",
				click:function(){
					var selectedTR = ${tableNamePojoNameMap[tableName]}Table.getSelected();
					if(selectedTR==null){
						sys.sysAlert("请选择删除的数据！");
					}else{
						sys.sysConfirm("删除操作不可恢复，您确定要继续吗？",function(){
							var ids=[];
							<#assign pk=pksMap[tableName][0]>
							<#assign columnJavaName2=columnJavaNameMap[tableName + "|" + pk] />
							ids[0]=selectedTR.${columnJavaName2};
							var data=deleteBatch${tableNamePojoNameMap[tableName]}(ids);
							if(data>0){
								$("#${tableNamePojoNameMap[tableName]}-table tbody tr.active").remove();
							}else{
								sys.sysAlert("删除失败，请重试！");
							}
						});
					}
				}
			}</#if>
			],
			titleText:"${tableComment}管理",//是否显示表头
			titleTextWidth:"col-md-3",//表头的宽度
			isSearch:false,//是否全列搜索
			header:[
			<#if pksMap[tableName]?exists>
			<#list pksMap[tableName] as columnName>
				<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
				<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			{
				label:"<#if columnCommentsMap[tableName + "|" + columnName]?exists>${columnCommentsMap[tableName + "|" + columnName]}<#else>${columnJavaName}</#if>",
				mColumn:"${columnJavaName}",//对应数据库的字段
				hidden:true,//该列是否隐藏
				sWidth:"",//该列的宽度
				fnRender:function(obj){}
			},
			</#list>
			</#if>
			<#if unPkColumns?exists>
			<#list unPkColumns as columnName>
				<#assign columnJavaType=columnJavaTypeMap[tableName + "|" + columnName] />
				<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			{
				label:"<#if columnCommentsMap[tableName + "|" + columnName]?exists>${columnCommentsMap[tableName + "|" + columnName]}<#else>${columnJavaName}</#if>",
				mColumn:"${columnJavaName}",
				hidden:false
			}<#if columnName_has_next>,</#if>
			</#list>
			</#if>],
			initComplete:function(){
				//表格绘制完成后处理的事件
			}
		});
	}
	exports.createTable = createTable;
});