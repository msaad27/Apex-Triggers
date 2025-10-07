trigger TriggerCon on Contact (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        ApexTriggerCon.beforeIns(trigger.new);
    }
     if(trigger.isBefore && trigger.isInsert){
        ApexTriggerCon.checkDuplicateCon(trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert){
        ApexTriggerCon.shareCon(trigger.new);
    }
}