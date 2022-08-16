public with sharing class ProjectManagerAssigner {
    
    public static void assignTimesheetManagerFromProject(List<Timesheet__c> insertedTimesheets) {
        Set<Id> projectIds = new Set<Id>();

        for(Timesheet__c timesheet : insertedTimesheets) {
            projectIds.add(timesheet.Project__c);
        }

        Map<Id, Project__c> assignedProjects = new Map<Id, Project__c>([SELECT Project_Manager__c
                                                                            FROM Project__c
                                                                            WHERE Id IN :projectIds]);

        for(Timesheet__c timesheet : insertedTimesheets) {
            if(assignedProjects.containsKey(timesheet.Project__c)) {
                timesheet.Project_Manager__c = assignedProjects.get(timesheet.Project__c).Project_Manager__c;
            }
        }
    }

    public static void updateTimesheetManagerOnProjectChange(Map<Id, Project__c> updatedProjectsMap) {

        List<Timesheet__c> childTimesheets = [SELECT Project_Manager__c, Project__c, Project__r.Project_Manager__c
                                                FROM Timesheet__c
                                                WHERE Project__c IN :updatedProjectsMap.keySet()];

        for(Timesheet__c timesheet : childTimesheets) {
            
            timesheet.Project_Manager__c = timesheet.Project__r.Project_Manager__c;
        }
        
        update childTimesheets;
    }

    public static void additionalMethod() {
        
    }
}
