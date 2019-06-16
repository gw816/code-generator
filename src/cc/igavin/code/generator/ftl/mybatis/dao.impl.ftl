<#include "../common/common.ftl">
package ${basePackage}.dao.impl;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import cc.igavin.mybatis.MybatisOperator;
import cc.igavin.jdbc.Paginator;
import cc.igavin.jdbc.PaginatorParam;
import ${basePackage}.model.${tableNamePojoNameMap[tableName]};
import ${basePackage}.dao.${tableNamePojoNameMap[tableName]}Dao;
import cc.igavin.jdbc.JdbcUtil;
import cc.igavin.jdbc.Paginator;
import cc.igavin.jdbc.PaginatorParam;

/**
 * ${tableComment}数据访问实现层
 * @author ${author}
 * @since ${currentTime}
 */
@Repository
public class ${tableNamePojoNameMap[tableName]}DaoImpl implements ${tableNamePojoNameMap[tableName]}Dao{
	private final String NAMESPACE="${basePackage}.mapper.${tableNamePojoNameMap[tableName]}.";
	@Autowired
	private MybatisOperator mybatisOperator;
	
	/**
	* 添加一条${tableComment}记录
	* @param elemType ${tableComment}对象
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int insert(${tableNamePojoNameMap[tableName]} elemType) throws DataAccessException{
		return mybatisOperator.insert(NAMESPACE+"insert", elemType);
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
		return mybatisOperator.delete(NAMESPACE+"delete", PK);
	}
	
	/**
	* 根据主键更新${tableComment}
	* @param elemType 要更新的对象
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int update(${tableNamePojoNameMap[tableName]} elemType) throws DataAccessException{
		return mybatisOperator.update(NAMESPACE+"update", elemType);
	}
	
	/**
	* 根据主键查询${tableComment}
	* @param PK 主键
	* @return ${tableNamePojoNameMap[tableName]} 查询到的对象
	* @throws DataAccessException
	*/
	@Override
	public ${tableNamePojoNameMap[tableName]} query(Map<String,Object> PK) throws DataAccessException{
		return mybatisOperator.selectOne(NAMESPACE+"query", PK);
	}
	
	/**
	* 根据主键批量更新${tableComment}
	* @param parameter List<${tableNamePojoNameMap[tableName]}> 对象集
	* @return int[] 每个对象对应执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int[] updateBatch(List<${tableNamePojoNameMap[tableName]}> parameter) throws DataAccessException{
		return mybatisOperator.batchUpdate(NAMESPACE+"update", parameter);
	}
	
	/**
	* 根据主键批量删除${tableComment}
	* @param Pks 主键集
	* @return int[] 每个对象对应执行成功的数量
	* @throws DataAccessException
	*/
	@Override
	public int[] deleteBatch(List<Map<String,Object>> PKs) throws DataAccessException{
		return mybatisOperator.batchDelete(NAMESPACE+"delete", PKs);
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
		return 0;
	}

	</#if>
	
	/**
	* 查询所有${tableComment}
	* @return ${tableComment}对象集
	* @throws DataAccessException
	*/
	@Override
	public List<${tableNamePojoNameMap[tableName]}> queryForList() throws DataAccessException{
		return mybatisOperator.selectList(NAMESPACE+"queryAll");
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
		return null;
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
		return 0;
	}
	
	/**
	* 批量添加${tableComment}
	* @param parameter List<${tableNamePojoNameMap[tableName]}>对象集
	* @return int[] 每个对象添加的成功数量
	* @throws DataAccessException
	*/
	@Override
	public int[] insertBatch(List<${tableNamePojoNameMap[tableName]}> parameter) throws DataAccessException{
		return mybatisOperator.batchInsert(NAMESPACE+"insert", parameter);
	}
	
	/**
	* 分页获取${tableComment}记录
	* @param param 条件
	* @return 分页结果
	* @throws DataAccessException
	*/
	@Override
	public Paginator<${tableNamePojoNameMap[tableName]}> queryForListPage(PaginatorParam<${tableNamePojoNameMap[tableName]}> param) throws DataAccessException{
		String sql=mybatisOperator.getSqlSession().getConfiguration().getMappedStatement(NAMESPACE+"page").getBoundSql(null).getSql();
		return JdbcUtil.getJdbcOperator().queryForPage(sql,
				new Book(), param);
	}
}