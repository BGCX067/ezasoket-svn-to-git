       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ERROR021.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

      **
      **  This file is part of OpenEZA aka "Open Source EZASOKET".
      **
      **  OpenEZA is free software: you can redistribute it and/or
      **  modify it under the terms of the GNU General Public License
      **  as published by the Free Software Foundation, either
      **  version 3 of the License, or (at your option)
      **  any later version.
      **
      **  OpenEZA is distributed in the hope that it will be useful,
      **  but WITHOUT ANY WARRANTY; without even the implied warranty of
      **  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      **  GNU General Public License for more details.
      **
      **  You should have received a copy of the
      **  GNU General Public License along with OpenEZA.
      **  If not, see <http://www.gnu.org/licenses/>.
      **

      * tests that 'Network is unreachable.'
      * in connect that it returns an error.

           COPY EZADATA.

       PROCEDURE DIVISION.

       MAINLINE.

           MOVE 'ERROR021' TO EZA-PROGRAM
           MOVE 5002       TO EZA-NAME-PORT

           PERFORM EZA-INITAPI
           PERFORM EZA-SOCKET
           PERFORM EZA-CONNECT

           GOBACK
           .

           COPY INITAPI.
           COPY SOCKET.
           COPY ABEND.

       EZA-CONNECT SECTION.
       CONNECT-START.
            MOVE 'CONNECT'  TO EZA-FUNCTION.
            MOVE 2          TO EZA-NAME-FAMILY
      * set ip to 10.10.10.10
            MOVE X'0a0a0a0a' TO EZA-NAME-IPADDRESS
 
            MOVE +0 TO EZA-ERRNO
            MOVE +0 TO EZA-RETCODE
            CALL 'EZASOKET'
                USING
                EZA-FUNCTION
                EZA-S
                EZA-NAME
                EZA-ERRNO
                EZA-RETCODE
            END-CALL
            IF EZA-RETCODE IS LESS THAN +0
      * I hope it will return ENETUNREACH
              IF EZA-ERRNO-ECONNREFUSED
                 DISPLAY 'PASS: CONNECT returned ECONNREFUSED'
              ELSE
                 DISPLAY 'FAIL: CONNECT returned wrong error code '
                         EZA-ERRNO '.'
              END-IF
           ELSE
              DISPLAY 'FAIL: CONNECT did not fail.'
           END-IF
           DISPLAY 'COMPLETE: CONNECT test completed.'
            .
        CONNECT-EXIT.
            EXIT.


