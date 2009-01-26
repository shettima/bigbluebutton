

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show Schedule</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Schedule List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Schedule</g:link></span>
        </div>
        <div class="body">
            <h1>Show Schedule</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Schedule Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'scheduleName')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Schedule Number:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'scheduleNumber')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Length Of Conference:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'lengthOfConference')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Number Of Attendees:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'numberOfAttendees')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Scheduled By:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'scheduledBy')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Date Created:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'dateCreated')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Last Updated:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'lastUpdated')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Record:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'record')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Start Date Time:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:scheduleInstance, field:'startDateTime')}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${scheduleInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
