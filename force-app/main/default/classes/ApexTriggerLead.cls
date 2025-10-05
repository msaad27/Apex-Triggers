public class ApexTriggerLead {

    // Prevent deletion of Leads with the status 'Working - Contacted'
    public static void preventDel(List<Lead> leadRecords) {
        for (Lead lead : leadRecords) {
            // Check the status and add an error if it matches
            if (lead.Status == 'Working - Contacted') {
                lead.addError('Cannot delete lead with status "Working - Contacted"');
            }
        }
    }

    // Update Status to 'Working - Contacted'
    public static void updateStatus(List<Lead> updateLeadStatus) {
        for (Lead newLead : updateLeadStatus) {
            newLead.Status = 'Working - Contacted';
        }
    }

    // Update Source and related fields based on Industry
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

    // Create tasks related to new leads
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

    // Ensure that 'Hot' leads have a valid Industry
    public static void validIndustry(List<Lead> leadRecords) {
        for (Lead l : leadRecords) {
            if (l.Rating == 'Cold' && l.Industry != 'Energy') {
               l.addError('Enter Industry for Cold rated leads');
            }
        }
    }
}