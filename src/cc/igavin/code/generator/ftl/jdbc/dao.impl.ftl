<#include "../common/common.ftl">
package ${basePackage}.dao.impl;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import cc.igavin.jdbc.DefaultJdbcOperations;
import cc.igavin.jdbc.Paginator;
import cc.igavin.jdbc.PaginatorParam;
import ${basePackage}.model.${tableNamePojoNameMap[tableName]};
import ${basePackage}.dao.${tableNamePojoNameMap[tableName]}Dao;

/**
 * ${tableComment}数据访问实现层
 * @author ${author}
 * @since ${currentTime}
 */
@Repository
public class ${tableNamePojoNameMap[tableName]}DaoImpl implements ${tableNamePojoNameMap[tableName]}Dao{
	@Autowired
	DefaultJdbcOperations jdbcOperator;
	
	/**
	* 添加一条${tableComment}记录
	* @param elemType ${tableComment}对象
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int insert(${tableNamePojoNameMap[tableName]} elemType) throws DataAccessException{
<#assign sql="insert into " + tableName + "(" />
<#list columnNames as columnName>
	<#assign sql=sql + columnName + "," />
</#list>
<#assign len=sql?length />
<#assign sql=sql?substring(0, sql?length - 1) + ") values(" />
<#list columnNames as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + ":" + columnJavaName + "," />
</#list>
<#assign sql=sql?substring(0, sql?length - 1) + ")" />
		String sql = "${sql}";
		return jdbcOperator.update(sql, elemType.toMap());
	}
	<#if pksMap[tableName]?exists>
	
	/**
	* 根据主键删除一条${tableComment}记录
	* @param PK 主键
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int delete(Map<String,Object> PK) throws DataAccessException{
<#assign sql="delete from " + tableName + " where 0=0" />
<#list pksMap[tableName] as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + " and " + columnName + "=:" + columnJavaName />
</#list>
		String sql = "${sql}";
		return jdbcOperator.update(sql, PK);
	}
	
	/**
	* 根据主键更新${tableComment}
	* @param elemType 要更新的对象
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int update(${tableNamePojoNameMap[tableName]} elemType) throws DataAccessException{
<#assign sql="update " + tableName + " set " />
<#list unPkColumns as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + columnName + "=:" + columnJavaName + ","/>
</#list>
<#assign sql=sql?substring(0, sql?length - 1) + " where 0=0" />
<#list pksMap[tableName] as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + " and " + columnName + "=:" + columnJavaName />
</#list>
		String sql = "${sql}";
		return jdbcOperator.update(sql, elemType.toMap());
	}
	
	/**
	* 根据主键查询${tableComment}
	* @param PK 主键
	* @return ${tableNamePojoNameMap[tableName]} 查询到的对象
	* @throws DataAccessException
	*/
	@Override
	public ${tableNamePojoNameMap[tableName]} query(Map<String,Object> PK) throws DataAccessException{
<#assign sql="select * from " + tableName + " where 0=0" />
<#list pksMap[tableName] as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + " and " + columnName + "=:" + columnJavaName />
</#list>
		String sql = "${sql}";
		return jdbcOperator.queryForObject(sql,PK,new ${tableNamePojoNameMap[tableName]}());
	}
	
	/**
	* 根据主键批量更新${tableComment}
	* @param parameter List<${tableNamePojoNameMap[tableName]}> 对象集
	* @return int[] 每个对象对应执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int[] updateBatch(List<${tableNamePojoNameMap[tableName]}> parameter) throws DataAccessException{
		<#assign sql="update " + tableName + " set " />
<#list unPkColumns as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + columnName + "=:" + columnJavaName + ","/>
</#list>
<#assign sql=sql?substring(0, sql?length - 1) + " where 0=0" />
<#list pksMap[tableName] as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + " and " + columnName + "=:" + columnJavaName />
</#list>
		String sql = "${sql}";
		@SuppressWarnings("unchecked")
		Map<String,?>[] maps=new Map[parameter.size()];
		for(int i=0;i<parameter.size();i++){
			maps[i]=parameter.get(i).toMap();
		}
		return jdbcOperator.batchUpdate(sql,maps);
	}
	
	/**
	* 根据主键批量删除${tableComment}
	* @param Pks 主键集
	* @return int[] 每个对象对应执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int[] deleteBatch(List<Map<String,Object>> PKs) throws DataAccessException{
		<#assign sql="delete from " + tableName + " where 0=0" />
<#list pksMap[tableName] as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + " and " + columnName + "=?" />
</#list>
		String sql = "${sql}";
		List<Object[]> list2=new ArrayList<Object[]>();
		List<Object> PKs2=new ArrayList<Object>();
		for(int i=0;i<PKs.size();i++){
			PKs2.clear();
		<#list pksMap[tableName] as columnName>
			<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
			PKs2.add(PKs.get(i).get("${columnJavaName}"));
		</#list>
			list2.add(PKs2.toArray());
		}
		return jdbcOperator.batchUpdate(sql,list2);
	}
	
	/**
	 * 更新${tableComment}部分内容
	 * 根据PK，和条件，只更新指定列的内容
	 * keys和values的长度必须一致，keys对应数据库表的字段名而不是属性名
	 * @param PK 主键
	 * @param keys 要修改的数据库字段名
	 * @param values 要修改的数据库字段值
	 * @return 更新成功的数量
	 * @throws DataAccessException
	 */
	@Override
	public int updatePart(Map<String,Object> PK, String[] keys, Object... values) throws DataAccessException{
	<#assign sql="update " + tableName + " set " />
		StringBuilder sql = new StringBuilder("${sql}");
		Map<String,Object> pk2=new HashMap<String, Object>();
		pk2.putAll(PK);
		for(int i=0,length=keys.length;i<length;i++){
			pk2.put(keys[i], values[i]);
			sql.append(keys[i]+"=:"+keys[i]);
			if(i<length-1){
				sql.append(",");
			}
		}
		sql.append(" where 0=0");
<#list pksMap[tableName] as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
		sql.append(" and ${columnName}=:${columnJavaName}");
</#list>
		
		return jdbcOperator.update(sql.toString(),pk2);
	}

	</#if>
	
	/**
	* 查询所有${tableComment}
	* @return ${tableComment}对象集
	* @throws DataAccessException
	*/
	@Override
	public List<${tableNamePojoNameMap[tableName]}> queryForList() throws DataAccessException{
		String sql = "select * from ${tableName}";
		return jdbcOperator.queryForList(sql,new ${tableNamePojoNameMap[tableName]}());
	}

	/**
	* 根据多个条件查询${tableComment}
	* @param keys 键名数组
	* @param values 对应键名数组长度的多个条件值
	* @return ${tableComment}对象集
	* @throws DataAccessException
	*/
	@Override
	public List<${tableNamePojoNameMap[tableName]}> queryForList(String[] keys,Object... values) throws DataAccessException{
		StringBuilder sql = new StringBuilder("select * from ${tableName} where 0=0 ");
		List<Object> finalValues=new ArrayList<Object>();
		for(int i=0;i<values.length;i++){
			Object value=values[i];
			if(value==null){
				sql.append(" and "+keys[i]+" is null");
			}else{
				sql.append(" and "+keys[i]+"=?");
				finalValues.add(value);
			}
		}
		return jdbcOperator.queryForList(sql.toString(),new ${tableNamePojoNameMap[tableName]}(),finalValues.toArray());
	}
	
	/**
	* 根据多个条件删除多个${tableComment}
	* @param keys 键名数组
	* @param values 对应键名数组长度的多个条件值
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int delete(String[] keys,Object... values) throws DataAccessException{
		StringBuilder sql = new StringBuilder("delete  from ${tableName} where 0=0 ");
		for(String key:keys){
			sql.append(" and "+key+"=?");
		}
		return jdbcOperator.update(sql.toString(), values);
	}
	
	/**
	* 批量添加${tableComment}
	* @param parameter List<${tableNamePojoNameMap[tableName]}>对象集
	* @return int[] 每个对象添加的成功数量
	* @throws DataAccessException
	*/
	@Override
	public int[] insertBatch(List<${tableNamePojoNameMap[tableName]}> parameter) throws DataAccessException{
		<#assign sql="insert into " + tableName + "(" />
<#list columnNames as columnName>
	<#assign sql=sql + columnName + "," />
</#list>
<#assign len=sql?length />
<#assign sql=sql?substring(0, sql?length - 1) + ") values(" />
<#list columnNames as columnName>
	<#assign columnJavaName=columnJavaNameMap[tableName + "|" + columnName] />
	<#assign sql=sql + ":" + columnJavaName + "," />
</#list>
<#assign sql=sql?substring(0, sql?length - 1) + ")" />
		String sql = "${sql}";
		@SuppressWarnings("unchecked")
		Map<String,?>[] maps=new Map[parameter.size()];
		for(int i=0;i<parameter.size();i++){
			maps[i]=parameter.get(i).toMap();
		}
		return jdbcOperator.batchUpdate(sql,maps);
	}
	
	/**
	* 分页获取${tableComment}记录
	* @param param 条件
	* @return 分页结果
	* @throws DataAccessException
	*/
	@Override
	public Paginator<${tableNamePojoNameMap[tableName]}> queryForListPage(PaginatorParam<${tableNamePojoNameMap[tableName]}> param) throws DataAccessException{
		String sql="select * from ${tableName}";
		return jdbcOperator.queryForPage(sql,new ${tableNamePojoNameMap[tableName]}(), param);
	}
}