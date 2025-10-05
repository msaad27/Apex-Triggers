trigger TriggerAcc on Account (before insert,before update ,after insert) {
    if(trigger.isBefore && trigger.isUpdate){
        ApexTriggerAcc.handleActivity(trigger.new,trigger.oldMap);
    }
    if(trigger.isBefore && trigger.isUpdate){
        ApexTriggerAcc.updatefield(trigger.new,trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isInsert){
        ApexTriggerAcc.insertCon(trigger.new);
    }
}