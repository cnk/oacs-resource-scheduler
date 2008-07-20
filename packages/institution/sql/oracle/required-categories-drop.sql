-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/required-categories-create.sql
--
-- PL/SQL to ensure that the certain categories, (expected by the Institution
-- package), that are created upon installation, are deleted.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-30
-- @cvs-id $Id: required-categories-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

begin
	----------------------------------------------------------------------------
	-- Categories for Address Objects ------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Contact Information//Address//Billing Address'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Address//Mailing Address'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Address//Work Address'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Address//Home Address'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Address'));								exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Categories for Email Address Objects ------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Contact Information//Email//Login Email Address'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Email//Personal Email Address'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Email//Work Email Address'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Email//Home Email Address'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Email'));								exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Categories for Phone Number Objects -------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Contact Information//Phone//Cell-phone Number'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Phone//Fax Number'));					exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Phone//Work Phone Number'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Phone//Home Phone Number'));			exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//Phone'));								exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Categories for URL Objects ----------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Contact Information//URL//Home Page'));						exception when others then null;	end;
	begin	category.delete(category.lookup('//Contact Information//URL'));									exception when others then null;	end;

	----------------------------------------------------------------------------
	--  ----------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Personnel Status//Accepting Patients'));						exception when others then null;	end;
	begin	category.delete(category.lookup('//Personnel Status'));											exception when others then null;	end;

	begin	category.delete(category.lookup('//Contact Information'));										exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Personnel Title Categories ----------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Personnel Title//Director'));								exception when others then null;	end;
	begin	category.delete(category.lookup('//Personnel Title//Faculty'));									exception when others then null;	end;
	begin	category.delete(category.lookup('//Personnel Title//Staff'));									exception when others then null;	end;
	begin	category.delete(category.lookup('//Personnel Title//Physician'));								exception when others then null;	end;
	begin	category.delete(category.lookup('//Personnel Title'));											exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Image -------------------------------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Image//Campus'));											exception when others then null;	end;
	begin	category.delete(category.lookup('//Image//Floorplan'));											exception when others then null;	end;
	begin	category.delete(category.lookup('//Image//Map'));												exception when others then null;	end;
	begin	category.delete(category.lookup('//Image//Other'));												exception when others then null;	end;
	begin	category.delete(category.lookup('//Image//Portrait'));											exception when others then null;	end;
	begin	category.delete(category.lookup('//Image'));													exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Education ---------------------------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//B.A.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//B.S.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//M.A.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//M.S.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//J.D.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//Ph.D.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree//Ed.D.'));				exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Degree'));					exception when others then null;	end;

	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//D.D.S.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//D.M.D.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//D.O.'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//D.P.M.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//M.B.'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//M.B.B.S.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//M.B.Ch.B.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//M.D.'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//M.S.N.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree//Psy.D.'));	exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Education//Medical Degree'));			exception when others then null;	end;

	begin	category.delete(category.lookup('//Certification Type//Education'));							exception when others then null;	end;


	----------------------------------------------------------------------------
	-- Medical Experience ------------------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Certification Type//Medical Experience//Internship'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Medical Experience//Fellowship'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Medical Experience//Residency'));		exception when others then null;	end;
	begin	category.delete(category.lookup('//Certification Type//Medical Experience'));					exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Medical Board Certification Categories ----------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Certification Type//Medical Board Certification'));			exception when others then null;	end;

	----------------------------------------------------------------------------
	-- License Categories ------------------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Certification Type//License'));								exception when others then null;	end;

	begin	category.delete(category.lookup('//Certification Type'));										exception when others then null;	end;

	----------------------------------------------------------------------------
	-- Group Categories --------------------------------------------------------
	----------------------------------------------------------------------------
	begin	category.delete(category.lookup('//Group Type//Department'));									exception when others then null;	end;
	begin	category.delete(category.lookup('//Group Type'));												exception when others then null;	end;
end;
/
show errors;
