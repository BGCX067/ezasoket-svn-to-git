       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ERROR006.

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

      * tests that if I pass a bad parm to SOCKET that it returns
      * an error.

           COPY EZADATA.

       PROCEDURE DIVISION.

       MAINLINE.

           MOVE 'ERROR006' TO EZA-PROGRAM
           MOVE 5678       TO EZA-NAME-PORT

           PERFORM EZA-INITAPI
           PERFORM EZA-SOCKET
           GOBACK
           .

           COPY INITAPI.
           COPY ABEND.

       EZA-SOCKET SECTION.
       SOCKET-START.
           MOVE 'SOCKET' TO EZA-FUNCTION
           MOVE 2 TO EZA-AF
           MOVE 1 TO EZA-SOCTYPE
      * Test protocol is vaild, and 1000 should be failed 
      * I don't know what error code should be returned,
      * EINVAL or EPROTONOSUPPORT
      * according to Rich's test, EPROTONOSUPPORT should be returned
           MOVE 1000 TO EZA-PROTO
           MOVE +0 TO EZA-ERRNO
           DISPLAY 'AF = ' EZA-AF
           CALL 'EZASOKET'
               USING
               EZA-FUNCTION
               EZA-AF
               EZA-SOCTYPE
               EZA-PROTO
               EZA-ERRNO
               EZA-RETCODE
           END-CALL
           IF EZA-RETCODE IS LESS THAN +0
              IF EZA-ERRNO-EPROTONOSUPPORT
                 DISPLAY 'PASS:  returned EPROTONOSUPPORT'
              ELSE
                 DISPLAY 'FAIL: SOCKET returned wrong error code '
                         EZA-ERRNO '.'
              END-IF
           ELSE
              DISPLAY 'FAIL: SOCKET did not fail.'
           END-IF
           DISPLAY 'COMPLETE: SOCKET test completed.'
           .

       SOCKET-EXIT.
           EXIT.

