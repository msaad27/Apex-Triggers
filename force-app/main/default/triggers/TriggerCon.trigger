trigger TriggerCon on Contact (before insert,after insert,after update ) {
    if(trigger.isBefore && trigger.isInsert){
        ApexTriggerCon.beforeIns(trigger.new);
    }
     if(trigger.isBefore && trigger.isInsert){
        ApexTriggerCon.checkDuplicateCon(trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert){
        ApexTriggerCon.shareCon(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        ApexTriggerCon.sendEmail(trigger.new,trigger.oldMap);
    }
}