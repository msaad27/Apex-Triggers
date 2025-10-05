trigger TriggerCon on Contact (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        ApexTriggerCon.beforeIns(trigger.new);
    }
}