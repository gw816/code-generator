<#include "../common/common.ftl">
package ${basePackage}.dao;

import ${basePackage}.model.${tableNamePojoNameMap[tableName]};
import org.springframework.stereotype.Repository;
import cc.igavin.commons.jpa.MyJpaRepository;
/**
 * ${tableComment}数据访问接口层
 * @author ${author}
 * @since ${currentTime}
 */
@Repository
public interface ${tableNamePojoNameMap[tableName]}Dao extends MyJpaRepository<${tableNamePojoNameMap[tableName]}, Long>{
}