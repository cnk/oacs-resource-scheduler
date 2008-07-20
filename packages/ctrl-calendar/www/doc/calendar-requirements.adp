<master>
<property name="title">Calendar System Requirements </property>

<h3> I. Introduction </h3>
The University is alive with scheduled events. A sytem that allows for decentralized event scheduling from a central web-based application can bring many tangible improvements over the current situation. This is the requirements doc for such a system. There are many overlapping similarities and points of tanget with the room reservation system and the Web-based Notification system. Where it is appropriate, those requirements will be referenced. 
<br> <img src="images/calendar.jpg" widht="400" height="300" alt="Calender system" align="right">
<h3> II. Vision Statement </h3>
Imagine that there is a web-based system maintained at the University that anyone associated with the University could log into and search for and receive a listing of all events that match a certain set of descriptors. 
Ideally this system would save a user's interests and then would monitor federated systems for events that match and periodically send out a notification. Additionally this system would have the ability to population a user's preferred calendar application with upcoming events. 

<h3> III. System Overview </h3>
<ul>
   <li> Open ACS 5.x system - Provides the framework for building the application. </li>
   <li> Room Reservation System - Provides the capacity to search for rooms where the event can be held </li> 
   <li> Comments module - Support for adding comments to events and tasks </li>
   <li> Categories - categorize the events and tasks. 
</ul>

<h3> IV. Use Cases </h3>
The Jonsson Comprehensive Cancer Center is a research organization that partially supports a wide range of researchers at the University. In addition, it facilitates communications and interaction across disciplines. One way it does this is by sponsoring and organizing talks and presentations -- seminars. There are a series of seminars, some named after donors, that follow a specific theme or topic area. Ususally these events are held in the same venue at fairly regular interval, like once a month, or the first wednesday of every other month. In line with their mission, they would like to be able to disseminate the time and place of each up-coming seminar to the academic community. Using the Event Scheduling & Calendaring System they can. 
From a link withing their own sites administrative section (private intranet) they reach the Event Scheduling & Calendaring System. Coming from this path the UI that greets them is nearly identical to what they are used to seeing within their own admin pages. They actually don't even notice that the URL has changed. 

<br><br>
Janie Browser visits the University calendar of events. She specifies that she is interested in viewing seminars and be notified by 
5 days prior to some events.  She clicks on the ones of interest and hits the submit button.  As an option, she can click on the download link to export 
 the seminars for the next three months in iCal format. ICal format is supported by iCalendar and Outlook.    

<br><br>
Raymond Organizer manages a group of rooms and occasionally plans the seminars for his department.  As part of the planning process he views 
the activiities that are going on that weekend on the calendar system to plan to ensure the largest attendance, such as avoiding conflicting schedules
with other talks that have similar topics.  He is able to do so on the calendar site by searching for events by date and  time period and/or  some keywords (optional).  
Upon finding a good date to plan for the seminar, Raymond enters the details and specifies a room is required.  The calendar system makes a request to the room reservation system and  returns a list of available appropriate rooms
for Raymond. Raymond sees the room he likes and since he has administrator rights for that room he reserves the rooom for the event.  Raymond recieves an email that the room reservation request  went thru and the time slot has been booked. 

<h3> V. Examples </h3>
See these URLs for more information regarding:<a href="http://www.scheduleworld.com"> 
ScheduleWorld.com</a>. ScheduleWorld is a free open standards based calendar compatible with programs like Microsoft Outlook and Lotus Notes. ScheduleWorld is written in 100% Java and works with Microsoft, Linux, Apple OS/X, and Solaris. 
IETF open calendaring and scheduling standards (RFCs <a href="http://www.faqs.org/rfcs/rfc2445.html"> 2445</a>, <a href="http://www.faqs.org/rfcs/rfc2446.html">2446</a>, <a href="http://www.faqs.org/rfcs/rfc2447.html">2447</a>) 

<h3> VI. Features </h3>

<br> 10.5 This application is timezone aware. 
<br> 10.7 Rule of thumb for activies that have start and ending date:  Start times are inclusive and end times are non inclusive. For example, if an 
event is recorded as started at 11 am and ended at 12 pm. 
 An events that ends at 11 am  and an event that  starts
at 12 pm do not cause scheduling conflict.
<br> 10.10 Event - An activity that begins and ends within a 24 hour period. 
<br> 10.10.10 The event has a title, location, notes, categories, capacity (optional), couple of miscellaneous fields, RSVP?, private or public,  and start and end date and time.  An event could be all day.
<br>
<br> 10.10.20 The event could be public or private.  Private events are only viewable by those designated by the event author.
<br> 10.10.20.20 Attendance types: open and  RSVP with and without admin approval 
<br> 10.10.20.20.5 RSVP has additional fields to store registration beginning and ending date.  The constraint on registration ending date is that it 
can not be after the end date of event.
<br> 10.10.20.20.10 Event registration pages are brandable to match the look and feel of external web site. 
<br> 10.10.20.20.10 public events are viewable by anyone visiting the  site.
<br> 10.10.20.20.20 private events are viewable by only those designate by calendar admin (i.e., UCLA users only, Department users only, etc).
<br> 10.10.20.20.30 Open events means anyone can attend.
<br> 10.10.20.20.40 RSVP is the same as open but there is a form to enter email, first_name, and last name. If they are member of the site then a
form is pre-populated with their information. 
<br> 10.10.20.20.50 For RSVP, flag to specify whether the capacity is taken into consideration. No more RSVP will be allowed once the capacity is reached
and/or event registration date has lapsed
<br> 10.10.25 Option to allow attendees to add comments about the event. 
<br>
<br> 10.10.30 Set up reminder notifications for event, such as nth days prior and after. These notifications could be sent to anyone with email not just 
 members of the site. 
<br> 10.10.50 Specify resources for the event such as rooms and projectors. 
<br> 10.10.55 Associated tasks
<br> 10.10.60 List of attendees.  Each attendee has a status and one or more roles.  Valid statuses are attending, pending, and declined.  Some
roles are attendees. 
<br> 10.10.70 Assignable admin permissions.
<br> 
<br> 10.20 Creating and Modifying an event
<br> 10.20.10 Events could overlap. Prompt confirmation during creation and editing an event. 
<br> 10.20.25 Specify attendees and their roles. An email is sent to prospective attendees with link to either RSVP or decline. 
<br> 10.20.40 Recurring event that is either daily, weekly, monthly or annually. 
<br> 10.20.50 Placing a request to use one or more room(s) to hold the event if necessary. 
<br>
<br> 10.10.90 Dropping/Canceling events 
<br> 10.10.90.10 If event has not lapsed, send email to attendees with a short description of why the event was canceled.  Delete the record.
<br> 10.10.90.20 If event has lapsed, mark the event as deleted instead of deleting the record. 
<br> 10.10.90.30 when removing a recurring event offer option to either delete the single ocurrence or include all subsequence entries.
<br> 10.10.90.40 Cancellation of event also cancels any reserved rooms.
<br> 10.10.90.50 All tasks tied to the event are also deleted 
<br>
<br> 10.20 Task - An activity that spans multiple days. 
<br> 10.20.10 Task has a title, notes, due date, priority, status, category, start and end date, and % completed
<br> 10.20.10.10 Percent completed is between 0 and 100 
<br> 10.20.10.20 Reminder notifications for a task, such as nth days prior and after. 
<br> 10.20.10.30 functionality to add comments.
<br>
<br> 10.30 Calendar and Scheduling management
<br> 10.30.10 Manage permissions for event, task, or calendar.  
<br> 10.30.20 Report of conflicting events and overdue tasks.  Color coding for events based on all tasks completed. 
<br> 10.30.30 Report of how many times an event was viewed and by whom. 
<br> 10.30.40 Option to specify timezone views. 
<br>
<br> 10.40 Calendar Public view
<br> 10.40.10 Different views of events for daily, weekly, monthly and yearly.  
<br> 10.40.20 Notification sign up for upcoming events either by category or a particular event. 
<br> 10.40.30 Post suggestion for upcoming events. 
<br> 10.40.40 Daily, weekly, monthly, and year views of the calendar
<br> 10.40.40.10 Daily view shows the events and the tasks for the day. Color coding for events that have tasks associated with them but are not completed yet (this for admin view only). 
<br> 10.40.50 A view of all ocurrences of a particular event.  
<br> 10.40.60 Exporting/Importing the event/task to another calendar application. Follows IETF open calendaring and scheduling standards (RFCs 2445) formatting to export events to another 
calendaring applications such as Outlook and iCal.  
<br> 10.40.60.10 Only support the capacity to publish events portion of RFC 2445.  No Support for coordination, journal, and other group interaction schemes.
<br> 10.40.60.20 Import from RFC 2445  and tab format (only for Outlook) events and tasks. There is no support for journal entries. 
<br>
<br> 10.50 Other Module Integration 
<br> 10.50.10 Room Reservation - Interface with room reservation module to reserve rooms 
<br> 10.50.10.10 Display the list of available rooms that satisfy event requirements, time and space. 
<br> 10.50.10.20 Support for reserving one or more rooms for an event. 
<br> 10.50.10.30 Cancel the room reservation upon event cancelation.
<br> 10.50.10.40 Handle request and confirmation of reservations
<br> 10.50.20 Digest - Interface with Digest to post events
<br> 10.50.20.10 API to pull events for a period of time

<h3>VII. Revision History</h3>

<table cellpadding=2 cellspacing=2 width=90% bgcolor=grey>
<tr bgcolor=teal>
    <th width=10%>Document Revision \#</th>
    <th width=50%>Action Taken, Notes</th>
    <th>When?</th>
    <th>By Whom?</th>
    </tr>
<tr>
    <td>0.1</td>
    <td>Creation</td>
    <td>07/09/2004</td>
    <td>Robert Dennis</td>
    </tr>
<tr>
    <td>.5</td>
    <td>Update</td>
    <td>07/27/2004</td>
    <td>Khy Huang</td>
    </tr>
<tr>
    <td>1.0</td>
    <td>Update</td>
    <td>09/09/2004</td>
    <td>Khy Huang</td>
    </tr>
<tr>
    <td>1.1</td>
    <td>Updates</td>
    <td>10/24/2004</td>
    <td>Robert Dennis</td>
    </tr>

</table>
