public without sharing class TestClass {
    
    @RemoteAction
    public static List<Account> getAccount(){
        return [select id, name, owner.name from account];
    }
    
    public class Row {
        String rowId { get; set; }
        String group3Name { get; set; }
        String group4Name { get; set; }
    }

    @AuraEnabled
    public static Map<String, Object> initData(Id goalId) {
        Map<String, Object> resultMap = new Map<String, Object>();
        
        // Application 가장 최근 Version 가져오기
        /*
        List<ShortageSimulation__c> accList = [
            SELECT 	Id, Application__c, CreatedDate
            FROM 	ShortageSimulation__c
            WHERE 	SalesGoal__c = :goalId
            ORDER BY Application__c
        ];
		*/
        
        // Application 별 Version 정보 List
        /*
        List<ShortageSimulationVer__c> ssVerList = [
            SELECT 	Id, ShortageSimulation__r.Application__c, Version__c, CreatedDate
            FROM 	ShortageSimulationVer__c
            WHERE 	ShortageSimulation__r.SalesGoal__c = :goalId
            ORDER BY Application__c
        ];
*/
        
        return resultMap;
    }
    
    /**
     *
	**/
    @AuraEnabled
    public static void initNewFormData() {
        String a, b, c, d, e = '0';
        // New Modal 시 Application Picklist 가져오기
        List<Object> accountStageMapList = getSinglePicklistLabelValue('Account', 'CustomerPriority__c');
		        
        // Sales Goal 에 기존재하는 Application Picklist 제거함
        Set<String> applicationSets = new Set<String>{'pc', 'high'};
        
        Set<Integer> removeTargetIdx = new Set<Integer>();
        Integer tempIndex = 0;
        for(Object pickObj : accountStageMapList) {
            Map<String, String> pickMap = (Map<String, String>)pickObj;
            String pickValue = String.valueOf(pickMap.get('value')).toLowerCase();
            if(applicationSets.contains(pickValue)) {
            	removeTargetIdx.add(tempIndex);
            }
            tempIndex++;
        }
        for(Integer i : removeTargetIdx) {
            accountStageMapList.remove(i);
        }
        
        system.debug(accountStageMapList);

        // Version 정보 가져오기
    }
    
    public static List<Object> getSinglePicklistLabelValue(String objectApiName, String fieldApiName) {
        Schema.DescribeFieldResult pickList = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();
        List<Schema.PicklistEntry> values = pickList.getPicklistValues();              
        
        List<Object> pickMapList = new List<Object>();
        for(Schema.PicklistEntry pick : values){
            Map<String, String> pickMap = new Map<String, String>();
            pickMap.put('label', pick.getLabel());
            pickMap.put('value', pick.getValue());
            pickMapList.add(pickMap);
        }
        return pickMapList;
    }
}