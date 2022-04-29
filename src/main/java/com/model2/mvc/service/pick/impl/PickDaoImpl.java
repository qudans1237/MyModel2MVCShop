package com.model2.mvc.service.pick.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Pick;
import com.model2.mvc.service.pick.PickDao;

@Repository("pickDaoImpl")
public class PickDaoImpl implements PickDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession=sqlSession;
	}
	
	@Override
	public void addPick(Pick pick) throws Exception {
		sqlSession.insert("PickMapper.addPick", pick);
	}
	
	@Override
	public Map<String, Object> getPickList(Search search, String buyerId) throws Exception {
		
		Map<String, Object> map = new HashMap<String,Object>();
		Pick pick = new Pick();
		
		map.put("endRowNum",  search.getEndRowNum()+"" );
		map.put("startRowNum",  search.getStartRowNum()+"" );
		map.put("buyerId", buyerId);
		
		List<Pick> list = sqlSession.selectList("PickMapper.getPickList",map);
		map.put("list", list);
		
		return map;
	}

	@Override
	public void deletePick(int prodNo) throws Exception {
		sqlSession.delete("PickMapper.deletePick", prodNo);
	}

	@Override
	public int getTotalCount(Search search) {
		return sqlSession.selectOne("PickMapper.getTotalCount", search);

	}


	


}
