<#include "common.ftl">
package ${basePackage}.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletResponse;
<#assign tableNamePojoName=tableNamePojoNameMap[tableName] />
<#assign firstSmallTableNamePojoName=tableNamePojoName?uncap_first />
import ${basePackage}.model.${tableNamePojoName};
import ${basePackage}.service.${tableNamePojoName}Service;
import ${basePackage}.dao.${tableNamePojoName}Dao;
import cc.igavin.common.poi.bigExcelExport.BigExcelCell;
import cc.igavin.common.poi.bigExcelExport.BigExcelExport;
import cc.igavin.commons.jpa.Paginator;
import cc.igavin.commons.jpa.PaginatorParam;
import cc.igavin.ucenter.common.core.utils.ClassUtils;
import cc.igavin.ucenter.common.core.utils.util.DateUtils;
import cc.igavin.ucenter.common.core.utils.FileUtils;
import cc.igavin.ucenter.common.core.utils.StringUtils;

/**
 * ${tableComment}服务实现层
 * @author ${author}
 * @since ${currentTime}
 */
@Transactional
@Service
public class ${tableNamePojoNameMap[tableName]}ServiceImpl implements ${tableNamePojoNameMap[tableName]}Service{
	@Autowired
	${tableNamePojoName}Dao ${firstSmallTableNamePojoName}dao;
	
	/**
	* 添加一条${tableComment}数据
	* @param a${tableNamePojoName} 添加的${tableComment}对象
	*/
	@Override
	public ${tableNamePojoName} add${tableNamePojoName}(${tableNamePojoName} a${tableNamePojoName}) {
		<#if pksMap[tableName]?exists>
		<#list pksMap[tableName] as columnName>
		<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		if(a${tableNamePojoName}.get${columnJavaName?cap_first}()==null){
			a${tableNamePojoName}.set${columnJavaName?cap_first}(StrUtil.getUUID());
		}
		</#list>
		</#if>
		return ${firstSmallTableNamePojoName}dao.save(a${tableNamePojoName});
	}
	<#if pksMap[tableName]?exists>
	
	/**
	* 根据主键删除一条${tableComment}数据
	* @param id 主键
	*/
	@Override
	public void delete${tableNamePojoName}(Long id) {
		${firstSmallTableNamePojoName}dao.delete(id);
	}

	/**
	* 更新一条${tableComment}
	* @param a${tableNamePojoName} 要更新的对象
	*/
	@Override
	public ${tableNamePojoName} update${tableNamePojoName}(${tableNamePojoName} a${tableNamePojoName}) {
		return ${firstSmallTableNamePojoName}dao.save(a${tableNamePojoName});
	}
	
	/**
	* 根据主键查询一条${tableComment}
	* @param id 主键
	* @return 查询到的${tableComment}对象
	*/
	@Override
	public ${tableNamePojoName} query${tableNamePojoName}(Long id){
		return ${firstSmallTableNamePojoName}dao.findOne(id);
	}
	
	/**
	*根据主键批量更新${tableComment}
	* @param parameters 对象集
	*/
	@Override
	public void updateBatch${tableNamePojoName}(List<${tableNamePojoName}> parameters) {
		if(null != parameters && parameters.size()>0){
			for(${tableNamePojoName} d:parameters){
				update${tableNamePojoName}(d);
			}
		}
	}
	
	/**
	*根据主键批量删除${tableComment}
	* @param ids 主键集
	*/
	@Override
	public void deleteBatch${tableNamePojoName}(List<Long> ids) {
		if(null != PKs && PKs.size()>0){
			for(String d:PKs){
				delete${tableNamePojoName}(d);
			}
		}
	}
	
	/**
	 * 从Excel文件中提取${tableComment}数据并入库（支持多文件）
	 * @param files 上传的excel文件
	 * @return 文件导入成功的个数
	 */
	@Override
	public int importData(MultipartFile[] files) {
		int count=0;
		
		return count;
	}
	</#if>
	
	/**
	 * 导出${tableComment}数据到excel文件
	 * @param response
	 */
	@Override
	public void exportData(HttpServletResponse response) {
		List<${tableNamePojoName}> ${tableNamePojoName}List= query${tableNamePojoName}List();
		if(${tableNamePojoName}List==null||${tableNamePojoName}List.size()==0){
			return;
		}
		List<Map<String,Object>> list =new ArrayList<Map<String,Object>>();
		for(${tableNamePojoName} a${tableNamePojoName}:${tableNamePojoName}List){
			list.add(ClassUtils.getPropertyValMap(a${tableNamePojoName}));
		}
		
		List<BigExcelCell> cellList=new ArrayList<BigExcelCell>();
		
		<#list unPkColumns as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		cellList.add(new BigExcelCell("${columnJavaName}","<#if columnCommentsMap[tableName + "|" + columnName]?exists>${columnCommentsMap[tableName + "|" + columnName]}<#else>${columnJavaName}</#if>"));
	</#list>
		File file=new File(DateUtils.getCurrentTime().getTime()+".xls");
		
		if(!file.exists()){
			try {
				file.createNewFile();
				new BigExcelExport(list,cellList).toFile(file.getAbsolutePath());
				FileUtils.downloadFile(file.getName(), file, response);
				file.delete();
			} catch (IOException e) {
				System.out.println("文件创建异常"+e.getMessage());
			}
		}
	}
	
	/**
	*查询所有${tableComment}数据
	* @return ${tableComment}对象集
	*/
	@Override
	public List<${tableNamePojoName}> query${tableNamePojoName}List() {
		return ${firstSmallTableNamePojoName}dao.findAll();
	}
	
	/**
	* 批量添加${tableComment}数据
	* @param parameters ${tableComment}对象集
	* @return int[] 每个对象添加的成功数量
	*/
	@Override
	public void addBatch${tableNamePojoName}(List<${tableNamePojoName}> parameters) {
		if(null != parameters && parameters.size()>0){
			for(${tableNamePojoName} d:parameters){
				add${tableNamePojoName}(d);
			}
		}
	}
	
	/**
	* 分页查询${tableComment}数据
	* @param param 条件
	* @return 分页结果
	*/
	@Override
	public Paginator<${tableNamePojoName}> query${tableNamePojoName}ListPage(PaginatorParam param) { 
		return ${firstSmallTableNamePojoName}dao.findAll(param) ;
	}
}