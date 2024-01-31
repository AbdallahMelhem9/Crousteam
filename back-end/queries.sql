-- SQL queries to be fed to anosql

-- name: now$
SELECT CURRENT_TIMESTAMP;

-- name: version$
SELECT VERSION();

-- CAUTION used in several places
-- name: get_auth_login^
SELECT password, isAdmin
FROM Auth
WHERE login = :login;

-- CAUTION may be used in several places
-- name: get_auth_login_lock^
SELECT password, isAdmin
FROM Auth
WHERE login = :login
FOR UPDATE;

-- name: get_auth_all
SELECT login, isAdmin
FROM Auth
ORDER BY 1;

-- name: insert_auth$
INSERT INTO Auth(login, password, isAdmin)
VALUES (:login, :password, :is_admin)
RETURNING lid;

-- name: delete_user!
DELETE FROM Auth WHERE login = :login;

-- name: get_messages
SELECT mtext, CASE WHEN login = :login THEN 1 ELSE 0 END AS a_ecrit, mtime
FROM Messages
JOIN AppGroup USING (gid)
JOIN Auth USING (lid)
WHERE gid = :gid
ORDER BY mtime DESC;

-- name: post_messages
INSERT INTO Messages(lid, mtext, gid)
VALUES (:lid, :mtext, :gid);

-- name: get_all_conversations
WITH Last_message_each_conversations AS (
    SELECT lid, mtext, MAX(mtime) AS max_mtime, gid FROM Messages GROUP BY 4, 2, 1 ORDER BY 3 DESC
), Group_without_messages AS (
    SELECT DISTINCT ag.gid, gname, creationDate FROM AppGroup AS ag
    JOIN UsersInGroup AS uig ON ag.gid=uig.gid
    LEFT JOIN Messages AS m ON ag.gid=m.gid
    WHERE m.gid IS NULL
)
SELECT gname FROM AppGroup AS ag
JOIN UsersInGroup AS uig ON uig.gid = ag.gid
JOIN Last_message_each_conversations AS lmec ON lmec.gid = ag.gid
JOIN Auth AS a ON uig.lid = a.lid
WHERE login = :login
UNION
SELECT gname FROM Group_without_messages AS gwm
JOIN UsersInGroup AS uig ON gwm.gid=uig.gid
JOIN Auth AS a ON uig.lid=a.lid
WHERE login = :login;
-- ORDER BY max_mtime DESC;
-- need group without messages on

-- name: get_lid_from_login$
SELECT lid FROM Auth WHERE login = :login;

-- name: post_info_register!
INSERT INTO Profile(lid, firstName, lastName, bio, naissance, photoPath)
VALUES (:lid, :firstName, :lastName, :bio, :naissance, :photoPath);

-- name: get_single_profile^
SELECT TRUE FROM Profile WHERE lid = (SELECT lid FROM Auth WHERE login = :login);

-- name: delete_info_profile!
DELETE FROM Profile WHERE lid = (SELECT lid FROM Auth WHERE login = :login);

-- name: all_info_profile
SELECT * FROM Profile;

-- name: update_info_profile!
UPDATE Profile
SET (firstName, lastName, bio, naissance, photoPath) = (:firstName, :lastName, :bio, :naissance, :photoPath)
WHERE lid = (SELECT lid FROM Auth WHERE login = :login);

-- name: create_group_of_two$
INSERT INTO AppGroup(gname)
VALUES ('')
RETURNING gid;

-- name: is_people_already_in_the_same_group$
SELECT DISTINCT TRUE
 FROM UsersInGroup AS g1 
 JOIN UsersInGroup AS g2 ON g1.gid = g2.gid
 JOIN AppGroup AS g ON g1.gid = g.gid
 WHERE isGroupChat = FALSE
   AND g1.lid = :lid1
   AND g2.lid = :lid2;

-- name: is_people_already_in_the_same_group_with_login$
SELECT DISTINCT gid
 FROM UsersInGroup AS g1 
 JOIN UsersInGroup AS g2 ON g1.gid = g2.gid
 JOIN AppGroup AS g ON g1.gid = g.gid
 WHERE isGroupChat = FALSE
   AND g1.lid = (SELECT lid FROM Auth WHERE login = :login1)
   AND g2.lid = (SELECT lid FROM Auth WHERE login = :login2);

-- name: add_people_into_group!
INSERT INTO UsersInGroup(gid, lid)
VALUES (:gid, :lid);

-- name: get_single_lid^
SELECT login FROM Auth WHERE lid = :lid;

-- name: get_single_group_chat^
SELECT TRUE FROM AppGroup WHERE gid = :gid;

-- name: delete_group_chat!
DELETE FROM AppGroup WHERE gid = :gid;

-- name: get_gid_of_a_group^
SELECT gid FROM AppGroup ORDER BY gid DESC LIMIT 1;

-- name: get_first_last_name^
SELECT firstName, lastName
FROM Profile
JOIN Auth USING(lid)
WHERE login = :login;

-- name: get_all_info^
SELECT * FROM Profile
JOIN Auth USING(lid)
WHERE login = :login;

-- name: preference_already^
SELECT TRUE FROM UsersPref AS u
JOIN Auth AS a
ON u.lid = a.lid
WHERE login = :login AND pfid = :pfid;

-- name: insert_preference!
INSERT INTO UsersPref (lid, pfid) 
VALUES ((SELECT lid FROM Auth WHERE login = :login), :pfid);

-- name: delete_preference!
DELETE FROM UsersPref
WHERE lid = (SELECT lid FROM Auth WHERE login = :login)
AND pfid = :pfid;

-- name: get_login_who_matches_with_preferences
WITH LoginPreferences AS (
    SELECT pfid FROM UsersPref JOIN Auth USING(lid) WHERE login = :login
)
SELECT DISTINCT login, bio, COUNT(*) FROM Auth 
JOIN UsersPref USING(lid)
JOIN Profile USING(lid)
WHERE pfid IN (SELECT pfid FROM LoginPreferences) AND login <> :login
GROUP BY login, bio
ORDER BY 3 DESC;

-- name: insert_preference_type!
INSERT INTO Preferences(pftype)
VALUES (:pftype);

-- name: get_single_preference_type$
SELECT TRUE FROM Preferences
WHERE pftype = :pftype;

-- name: delete_preference_type!
DELETE FROM Preferences
WHERE pftype = :pftype;

-- name: get_all_user_preferences!
SELECT pftype 
FROM Preferences
JOIN UsersPref USING(pfid)
JOIN Auth USING(lid)
WHERE login = :login;


-- name: get_all_preferences
SELECT pftype 
FROM Preferences;

-- name: get_single_event^
SELECT TRUE FROM Event
WHERE ename = :ename AND eloc = :eloc AND etime = :etime;

-- name: get_single_event_with_eid^
SELECT TRUE FROM Event
WHERE eid = :eid;

-- name: create_group_chat_link_to_the_event$
INSERT INTO AppGroup(gname, isGroupChat)
VALUES (:ename, TRUE)
RETURNING gid;

-- name: add_event$
INSERT INTO Event (ename, eloc, etime, tid, gid)
VALUES (:ename, :eloc, :etime, :tid, :gid)
RETURNING eid;

-- name: delete_event!
DELETE FROM Event
WHERE eid = :eid;

-- name: get_group_of_event$
SELECT gid FROM Event WHERE eid = :eid;

-- name: get_if_people_into_group^
SELECT TRUE FROM UsersInGroup WHERE gid = :gid AND lid = :lid;
