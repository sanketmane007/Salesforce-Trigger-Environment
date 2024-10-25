//=== This Is Handle Class called From Opportunity Line Item Trigger =================
public with sharing class HandlerOppLineItemAssetCreate2{
    
    public static void craeteAssetMethod(List<OpportunityLineItem> oppLineItems){

        Set<Id> oppIds =new Set<Id>();
        List<Asset> lstAsset =new List<Asset>();
        for (OpportunityLineItem oppValue : oppLineItems) {
            oppIds.add(oppValue.OpportunityId);
        }

        List<Opportunity>  oppList  = [SELECT Id,Account.Name,AccountId
                                    FROM Opportunity WHERE Id IN:oppIds ];

            if (!oppList.isEmpty()) {
                for (Opportunity opp : oppList) {

                    Asset ass =new Asset();
                    ass.Name = opp.Account.Name+' OPL';
                    ass.AccountId = opp.AccountId;
                    lstAsset.add(ass);
                }
            }

            if (!lstAsset.isEmpty()) {
                insert lstAsset;
            }
    }

}