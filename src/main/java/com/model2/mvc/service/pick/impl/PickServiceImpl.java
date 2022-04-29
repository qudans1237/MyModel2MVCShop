package com.model2.mvc.service.pick.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Pick;
import com.model2.mvc.service.pick.PickService;
import com.model2.mvc.service.pick.PickDao;

@Service("pickServiceImpl")
public class PickServiceImpl implements PickService {

	@Autowired
	@Qualifier("pickDaoImpl")
	private PickDao pickDao;
	
	@Override
	public Map<String, Object> getPickList(Search search, String buyerId) throws Exception {
		int totalCount = pickDao.getTotalCount(search);
		
		Map<String, Object> map = pickDao.getPickList(search, buyerId);
		map.put("totalCount", new Integer(totalCount));
		
		return map;
	}

	@Override
	public void addPick(Pick pick) throws Exception {
		pickDao.addPick(pick);
	}

	@Override
	public void deletePick(int prodNo) throws Exception {
		pickDao.deletePick(prodNo);
		
	}

}