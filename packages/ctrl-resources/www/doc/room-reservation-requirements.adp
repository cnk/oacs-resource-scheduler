<master>
<property name="title">DGSOM Room Reservation System Requirements </property>


<h3> I. Introduction </h3>

Lenny Rome, Sr. Assoc. Dean for Research, has suggested that there's a need for a central room reservation system that could be utilizied by all departments within the David Geffen School of Medicine. This is the requirements document for such a system. It will be an OpenACS 5.X-based system with Web Service, or RSS (or both), and iCal (or other calendar client) services for communication of scheduled events to people's calendars. 
<br><img src="images/room-reservation.jpg" width="490" height="300" alt="Room Reservation system" align="right">
<h3> II. Vision Statement </h3>

Managing room reservations are tasks that every department faces. Often a single individual is given the responsibility of managing a conference or general purpose room that itself may have shared resources like an LCD projectors that are used in that room. In addition, there are shared classrooms that are used for a variety of purposes by a range of people from different departments. It seems that the current approach is very uncentralized and solutions are diverse. Off-line, paper-based management is still often used. A web-based approach that would preserve local authority yet centralize and standardize a solution to the problem will bring many tangible benefits. Among the advantages of a centralized reservation system are the pooling of resources and the capability of offering alternatives in the case of scheduling conflicts. This system will provide a web interface for scheduling, and it will publish approved schedules in a manner that a wide range of calendar clients can display them. Apple Mac iCal users will be able to add events for a particular venue to their calendar. Similarly, users of MS Exchange will be able to connect and display events within Outlook. The vision is of a web-based system that can present to local room administrators a system that makes the task of managng their resources easier. The more people that utilize the system the greater the advantage to all users. However, this system is not meant to wrestle control over room schedule from those who current hold it. 

<h3> III. System Overview  </h3>
<ul>
   <li> Open ACS 5.x system - Provides the framework for building the application. </li>
   <li> Categories - group rooms together
   <li> Calendaring system - to provide a calendar UI to the management of resources.
</ul>



<h3> IV.Use Cases </h3>

Dr. Tom is an instructor who has been asked to teach a refresher class for in-coming students on statistics. The class will be for 3 hours, and the program administrator has asked if Dr. Phil can teach it on Tuesday of next week. Dr. Phil agrees, so he goes to the DGSOM Room Reservation System to book that time slot. He enters into a web form information about the event: date/time, number of expected attendees, LCD, and Ethernet connection requirements. The system presents him with a confirmation of the data he entered and the information that the room he requested in available during the time slot that he requested. His class is placed on the calendar for that room and an email message is sent to the administrator of that room. 
<p>
Dr. Tom was a hugh success last week, and so he has been asked to teach another class next tuesday on how to use SPSS, a stats package, to run ANOVA. Dr. Tom goes back to the Room Reservation Web site, and expects his local department's conference room to be available for that time slot next Tuesday. When he enters the basic info, like event title, date and time, he sees that his regular room is not available. The system reports that although his conference room is already booked for that date/time, there are a couple of other rooms nearby that are available. He completes the required additional information and submits his request. That time slot then shows on the room's calendar as being tenatively reserved. Since the room which the system has suggested is not in Dr. Tom local control, his request needs to be approved by that room's administrator. The room administrator receives an email that a user has requested to use the room. The administrator clicks a link in the email notification and goes driectly to the room's admin interface. The room administrator sees that the date/time Dr. Tom has requested is completely open and so he approved the request. The event is then displayed on the room's calendar as having been approved. Dr. Tom receives an email that his request ok has been approved. 
<p>
Dan is an administrative assistant who has been given the responsbility of managing the department's conference rooms. One of the conference rooms is also often used as a classroom, and it gets a lot of use. Most of the events are department-related but occasionally the room is used by people outside of the department. With the introduction of the new Room-Reservation system Dan's life has improved. It is now much easier for him to manage all the room requests. The process has now been moved to the Web. Once a month, Dan goes to an admin page for the rooms that he manages. He logs into the system and sees a web interface that looks like it is part of his own department's web system. He adds events that are new and need to be added. Periodically Dan gets an email message from the room reservation system telling him that someone has request to use the conference room. As long as the time slot is not needed by others in the department, Dan generally approves them. 
<p> 
Jake oversees two rooms (R1 and R2) for his department.  Each room has its own set of policies.  R1 is reservable by  everyone freely.  R2 is reservable only by members
in a privileged group, but on most Wednesdays the room is open. On Wednesdays the rooom is available for a fee. Jake's responsibility is to administer both rooms.  Jake opens the room for other groups in the department and specifies that these reservations require
his approval. 

<h3> V. Examples  </h3>


<h3> VI. Features </h3>
<br> 10.5 This application is timezone aware. 
<br> 10.7 Rule of thumb for activies that have start and ending date:  Start date are inclusive and end date are non inclusive. For example, if an 
event is recorded as starting at 11am, then  events that end at 11 am and  start
at 12 pm do not cause scheduling conflict.
<br>10.10 Room - a space with limited capacity, characteristics, location,  and set of resources.
<br>10.10.10  Room fields are name, description, cost and unit (if any), enable/disable, capacity, category, approval required or open, 
dates that available, building code, GIS coordinates,  policy description, on-line reservable, how-to reserve, and location (open text).
<br>10.10.15  Available hours for reservation.
<br>10.10.20  Block out dates for maintenance and admin activities.
<br>10.10.30  Assignable permissions to individuals and/or groups for editing the room properties, approving reservations, and creating approved and unapproved reservations.
<br>10.10.50  Set of resources such as projectors, remote conferencing , etc ....
<br>10.10.60  Minimum interval reserve unit, such as 15 minutes, 30 minutes, 1 hour, and 1 day 
<br>10.10.70  For recurring reservations specify the maximum number of repeats.
<br>10.10.80  A link of services available for a room.
<br>
<br>10.20 Policies for editing and modifying room attributes.  This requires room edit privilege. These policies only
apply to rooms that store reservations on site. 
<br>10.20.10 Editing certain attributes may result in conflicts with current reservations such as capacity.  If a change
conflicts provide confirmation page and reason for making change. This will not result in reservations being canceled. An email 
is sent to the person(s) that made the reservations w/ the option to cancel.  Modifications to name, capacity, and policy descriptions require
email notification.
<br>10.20.20 Creating block out periods may not conflict with 'approved' reservations.
<br>10.20.30 If a member is removed from the list of members that may make reservation, provide options
as to what actions should be taken.  Available actions for admin are to cancel future reservations of removed individual or do nothing. 
<br>
<br>10.30 Reservations - request to use a room for a period of time. The fields are title, start and end time, event, special requests, and person
making the request. 
<br>10.30.5  Reservation are either pending, canceled, confirmed, and approved.  
<br>10.30.10  Functionality to search applicable fields for available rooms. The rooms return from the search should be limited
to those that the user has permissions to reserve. 
<br>10.30.10.10 If desired  room is un available recommend a list of rooms with similar properties.
<br>10.30.10.20 Rooms that specify on-line reservable is false, a link takes the user to a page that displays how-to reserve. 
<br>10.30.20 A reservation is either pending or approved based on the room setting.  
<br>10.30.30 There can be  multiple pending reservations for one room for a period of time, but only one active reservation. When a pending reservation is approved then other conflicting pending reservations are denied and the requestors are  notified. 
<br>10.30.40 Recurring reservations - Create a reservation for a room on continuous basis either daily, weekly, and monthly. 
<br>
<br>10.40 Modify Reservations - Editing the reservations requires the same checks as making a reservation
<br>10.40.10 Person may only modify their 'pending' reservations, which is the same as making a new reservation. 
<br>10.40.20 Reservation state changes require an explanation and emails to be sent to the admins and reserver for these cases:
<ul>
     <li> pending to canceled (Only if admin cancel, otherwise email is sent only to the reserver) </li>
     <li> canceled to pending </li>
     <li> canceled to active </li> 
</ul> For other state changes email is optional and at the discretion of person initiating the action.  When a reservation is approved all pending
reservations for the same room with overlapping time frame is canceled. 
<br>
<br>10.50 Room management - Admin functionality 
<br>10.50.10 Create/Cancel/Approve reservations 
<br>10.50.20 Add new rooms and setup permissions
<br>10.50.30 daily, weekly, monthly, and yearly view of the room schedule 
<br>10.50.40 Report of room usage broken down by hours per user
<br>
<br>10.70 Module Integration
<br>10.70.10 Provide methods for other apps to create and/or cancel a room reservation. 
<br>10.70.20 Provide methods for other apps to query available rooms and their information. 
<br>10.70.25 Provide methods for other apps to query all rooms 
<br>10.70.30 Notification to other apps if one of their reservations has been canceled. 
<br>10.70.40 List of reservations for one member per room 
   
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
    <td>Updated features </td>
    <td>09/09/2004</td>
    <td>Khy Huang</td>
    </tr>
<tr>
    <td>1.1</td>
    <td>Updates</td>
    <td>10/22/2004</td>
    <td>Robert Dennis</td>
    </tr>

</table>

 
