package com.model2.mvc.service.pick;

import java.util.Map;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Pick;


public interface PickDao {
	public void addPick(Pick pick) throws Exception;
	
	public Map<String,Object> getPickList(Search search,String buyerId) throws Exception;
	
	public void deletePick(int prodNo) throws Exception;
	
	public int getTotalCount(Search search);
}
