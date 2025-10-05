trigger TriggerCase on Case (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
	ApexTriggerCase.changePriority(trigger.new);
    }
}