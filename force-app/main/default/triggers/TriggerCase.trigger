trigger TriggerCase on Case (before insert,before delete) {
    if(Trigger.isBefore && Trigger.isInsert){
	ApexTriggerCase.changePriority(trigger.new);
    }
    if(trigger.isBefore && trigger.isDelete){
       ApexTriggerCase.preventCaseDel(trigger.old);
    }
}