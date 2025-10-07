public class ApexTriggerLead {
    
    // Use case 12: Whenever a Lead is deleted, if the Lead Status is 'Working - Contacted', prevent the deletion and display an error message "Cannot delete lead with status 'Working - Contacted'".
    public static void preventDel(List<Lead> leadRecords) {
        for (Lead lead : leadRecords) {
            // Check the status and add an error if it matches
            if (lead.Status == 'Working - Contacted') {
                lead.addError('Cannot delete lead with status "Working - Contacted"');
            }
        }
    }

   //Use case 2 : Whenever a Lead record is updated, set the Lead Status to Working-Contacted
    public static void updateStatus(List<Lead> updateLeadStatus) {
        for (Lead newLead : updateLeadStatus) {
            newLead.Status = 'Working - Contacted';
        }
    }

    // Use case 4: Whenever a Lead record is updated, if the Industry is 'Healthcare', set Lead Source to 'Purchase List', SIC Code to '1100', and Primary to 'Yes'. If Industry is not 'Healthcare', clear these fields.
    public static void updateSource(List<Lead> leadRecords) {
        for (Lead newLead : leadRecords) {
            if (newLead.Industry == 'Healthcare') {
                newLead.LeadSource = 'Purchase List';
                newLead.SICCode__c = '1100';
                newLead.Primary__c = 'Yes';
            } else {
                // Clear fields if Industry is NOT Healthcare
                newLead.LeadSource = '';
                newLead.SICCode__c = '';
                newLead.Primary__c = '';
            }
        }
    }

    // Use case 6: Whenever a Lead is created, create a Task with Description as 'Follow up' and assign it to the Lead Owner.
    public static void createTask(List<Lead> newRecords) {
        List<Task> insertTask = new List<Task>();

        for (Lead l : newRecords) {
            Task taskRec = new Task();
            taskRec.OwnerId = l.OwnerId;
            taskRec.Description = 'Follow up';
            taskRec.WhoId = l.Id;
            insertTask.add(taskRec);
        }

        if (!insertTask.isEmpty()) {
            insert insertTask;
        }
    }

    //use case  12: Whenever a Lead's Rating is 'Cold' and Industry is not 'Energy', prevent the update and display an error message "Enter Industry for Cold rated leads".
    public static void validIndustry(List<Lead> leadRecords) {
        for (Lead l : leadRecords) {
            if (l.Rating == 'Cold' && l.Industry != 'Energy') {
               l.addError('Enter Industry for Cold rated leads');
            }
        }
    }
}