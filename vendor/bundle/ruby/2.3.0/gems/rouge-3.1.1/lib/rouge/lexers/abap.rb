# -*- coding: utf-8 -*- #
# ABAP elements taken from http://help.sap.com/abapdocu_750/en/index.htm?file=abapdo.htm

module Rouge
  module Lexers
    class ABAP < RegexLexer
      title "ABAP"
      desc "SAP - Advanced Business Application Programming"
      tag 'abap'
      filenames '*.abap'
      mimetypes 'text/x-abap'

      def self.keywords
        @keywords = Set.new %w(
          *-INPUT ?TO ABAP-SOURCE ABBREVIATED ABS ABSTRACT ACCEPT ACCEPTING
          ACCORDING ACCP ACTIVATION ACTUAL ADD ADD-CORRESPONDING ADJACENT
          AFTER ALIAS ALIASES ALIGN ALL ALLOCATE ALPHA ANALYSIS ANALYZER AND
          ANY APPEND APPENDAGE APPENDING APPLICATION ARCHIVE AREA ARITHMETIC
          AS ASCENDING ASPECT ASSERT ASSIGN ASSIGNED ASSIGNING ASSOCIATION
          ASYNCHRONOUS AT ATTRIBUTES AUTHORITY AUTHORITY-CHECK AVG BACK
          BACKGROUND BACKUP BACKWARD BADI BASE BEFORE BEGIN BETWEEN BIG BINARY
          BINTOHEX BIT BIT-AND BIT-NOT BIT-OR BIT-XOR BLACK BLANK BLANKS BLOB
          BLOCK BLOCKS BLUE BOUND BOUNDARIES BOUNDS BOXED BREAK-POINT BT
          BUFFER BY BYPASSING BYTE BYTE-CA BYTE-CN BYTE-CO BYTE-CS BYTE-NA
          BYTE-NS BYTE-ORDER CA CALL CALLING CASE CAST CASTING CATCH CEIL
          CENTER CENTERED CHAIN CHAIN-INPUT CHAIN-REQUEST CHANGE CHANGING
          CHANNELS CHAR CHAR-TO-HEX CHARACTER CHECK CHECKBOX CIRCULAR CLASS
          CLASS-CODING CLASS-DATA CLASS-EVENTS CLASS-METHODS CLASS-POOL
          CLEANUP CLEAR CLIENT CLNT CLOB CLOCK CLOSE CN CO COALESCE CODE
          CODING COLLECT COLOR COLUMN COLUMNS COL_BACKGROUND COL_GROUP
          COL_HEADING COL_KEY COL_NEGATIVE COL_NORMAL COL_POSITIVE COL_TOTAL
          COMMENT COMMENTS COMMIT COMMON COMMUNICATION COMPARING COMPONENT
          COMPONENTS COMPRESSION COMPUTE CONCAT CONCATENATE CONCAT_WITH_SPACE
          COND CONDENSE CONDITION CONNECT CONNECTION CONSTANTS CONTEXT
          CONTEXTS CONTINUE CONTROL CONTROLS CONV CONVERSION CONVERT COPIES
          COPY CORRESPONDING COUNT COUNTRY COVER CP CPI CREATE CREATING
          CRITICAL CS CUKY CURR CURRENCY CURRENCY_CONVERSION CURRENT CURSOR
          CURSOR-SELECTION CUSTOMER CUSTOMER-FUNCTION CX_DYNAMIC_CHECK
          CX_NO_CHECK CX_ROOT CX_SQL_EXCEPTION CX_STATIC_CHECK DANGEROUS DATA
          DATABASE DATAINFO DATASET DATE DATS DATS_ADD_DAYS DATS_ADD_MONTHS
          DATS_DAYS_BETWEEN DATS_IS_VALID DAYLIGHT DD/MM/YY DD/MM/YYYY DDMMYY
          DEALLOCATE DEC DECIMALS DECIMAL_SHIFT DECLARATIONS DEEP DEFAULT
          DEFERRED DEFINE DEFINING DEFINITION DELETE DELETING DEMAND
          DEPARTMENT DESCENDING DESCRIBE DESTINATION DETAIL DF16_DEC DF16_RAW
          DF16_SCL DF34_DEC DF34_RAW DF34_SCL DIALOG DIRECTORY DISCONNECT
          DISPLAY DISPLAY-MODE DISTANCE DISTINCT DIV DIVIDE
          DIVIDE-CORRESPONDING DIVISION DO DUMMY DUPLICATE DUPLICATES DURATION
          DURING DYNAMIC DYNPRO E EDIT EDITOR-CALL ELSE ELSEIF EMPTY ENABLED
          ENABLING ENCODING END END-ENHANCEMENT-SECTION END-LINES
          END-OF-DEFINITION END-OF-FILE END-OF-PAGE END-OF-SELECTION
          END-TEST-INJECTION END-TEST-SEAM ENDAT ENDCASE ENDCATCH ENDCHAIN
          ENDCLASS ENDDO ENDENHANCEMENT ENDEXEC ENDFORM ENDFUNCTION ENDIAN
          ENDIF ENDING ENDINTERFACE ENDLOOP ENDMETHOD ENDMODULE ENDON
          ENDPROVIDE ENDSELECT ENDTRY ENDWHILE ENDWITH ENGINEERING ENHANCEMENT
          ENHANCEMENT-POINT ENHANCEMENT-SECTION ENHANCEMENTS ENTRIES ENTRY
          ENVIRONMENT EQ EQUIV ERRORMESSAGE ERRORS ESCAPE ESCAPING EVENT
          EVENTS EXACT EXCEPT EXCEPTION EXCEPTION-TABLE EXCEPTIONS EXCLUDE
          EXCLUDING EXEC EXECUTE EXISTS EXIT EXIT-COMMAND EXPAND EXPANDING
          EXPIRATION EXPLICIT EXPONENT EXPORT EXPORTING EXTEND EXTENDED
          EXTENSION EXTRACT FAIL FETCH FIELD FIELD-GROUPS FIELD-SYMBOL
          FIELD-SYMBOLS FIELDS FILE FILTER FILTER-TABLE FILTERS FINAL FIND
          FIRST FIRST-LINE FIXED-POINT FKEQ FKGE FLOOR FLTP FLUSH FONT FOR
          FORM FORMAT FORWARD FOUND FRAME FRAMES FREE FRIENDS FROM FUNCTION
          FUNCTION-POOL FUNCTIONALITY FURTHER GAPS GE GENERATE GET
          GET_PRINT_PARAMETERS GIVING GKEQ GKGE GLOBAL GRANT GREEN GROUP
          GROUPS GT HANDLE HANDLER HARMLESS HASHED HAVING HDB HEAD-LINES
          HEADER HEADERS HEADING HELP-ID HELP-REQUEST HEXTOBIN HIDE HIGH HINT
          HOLD HOTSPOT I ICON ID IDENTIFICATION IDENTIFIER IDS IF
          IF_ABAP_CLOSE_RESOURCE IF_ABAP_CODEPAGE IF_ABAP_DB_BLOB_HANDLE
          IF_ABAP_DB_CLOB_HANDLE IF_ABAP_DB_LOB_HANDLE IF_ABAP_DB_READER
          IF_ABAP_DB_WRITER IF_ABAP_READER IF_ABAP_WRITER IF_MESSAGE
          IF_OS_CA_INSTANCE IF_OS_CA_PERSISTENCY IF_OS_FACTORY IF_OS_QUERY
          IF_OS_QUERY_MANAGER IF_OS_QUERY_OPTIONS IF_OS_STATE
          IF_OS_TRANSACTION IF_OS_TRANSACTION_MANAGER IF_SERIALIZABLE_OBJECT
          IF_SHM_BUILD_INSTANCE IF_SYSTEM_UUID IF_T100_DYN_MSG IF_T100_MESSAGE
          IGNORE IGNORING IMMEDIATELY IMPLEMENTATION IMPLEMENTATIONS
          IMPLEMENTED IMPLICIT IMPORT IMPORTING IN INACTIVE INCL INCLUDE
          INCLUDES INCLUDING INCREMENT INDEX INDEX-LINE INFOTYPES INHERITING
          INIT INITIAL INITIALIZATION INNER INOUT INPUT INSERT INSTANCE
          INSTANCES INSTR INT1 INT2 INT4 INT8 INTENSIFIED INTERFACE
          INTERFACE-POOL INTERFACES INTERNAL INTERVALS INTO INVERSE
          INVERTED-DATE IS ISO ITNO JOB JOIN KEEP KEEPING KERNEL KEY KEYS
          KEYWORDS KIND LANG LANGUAGE LAST LATE LAYOUT LCHR LDB_PROCESS LE
          LEADING LEAVE LEFT LEFT-JUSTIFIED LEFTPLUS LEFTSPACE LEGACY LENGTH
          LET LEVEL LEVELS LIKE LINE LINE-COUNT LINE-SELECTION LINE-SIZE
          LINEFEED LINES LIST LIST-PROCESSING LISTBOX LITTLE LLANG LOAD
          LOAD-OF-PROGRAM LOB LOCAL LOCALE LOCATOR LOG-POINT LOGFILE LOGICAL
          LONG LOOP LOW LOWER LPAD LPI LRAW LT LTRIM M MAIL MAIN MAJOR-ID
          MAPPING MARGIN MARK MASK MATCH MATCHCODE MAX MAXIMUM MEDIUM MEMBERS
          MEMORY MESH MESSAGE MESSAGE-ID MESSAGES MESSAGING METHOD METHODS MIN
          MINIMUM MINOR-ID MM/DD/YY MM/DD/YYYY MMDDYY MOD MODE MODIF MODIFIER
          MODIFY MODULE MOVE MOVE-CORRESPONDING MULTIPLY
          MULTIPLY-CORRESPONDING NA NAME NAMETAB NATIVE NB NE NESTED NESTING
          NEW NEW-LINE NEW-PAGE NEW-SECTION NEXT NO NO-DISPLAY NO-EXTENSION
          NO-GAP NO-GAPS NO-GROUPING NO-HEADING NO-SCROLLING NO-SIGN NO-TITLE
          NO-TOPOFPAGE NO-ZERO NODE NODES NON-UNICODE NON-UNIQUE NOT NP NS
          NULL NUMBER NUMC O OBJECT OBJECTS OBLIGATORY OCCURRENCE OCCURRENCES
          OCCURS OF OFF OFFSET ON ONLY OPEN OPTION OPTIONAL OPTIONS OR ORDER
          OTHER OTHERS OUT OUTER OUTPUT OUTPUT-LENGTH OVERFLOW OVERLAY PACK
          PACKAGE PAD PADDING PAGE PAGES PARAMETER PARAMETER-TABLE PARAMETERS
          PART PARTIALLY PATTERN PERCENTAGE PERFORM PERFORMING PERSON PF
          PF-STATUS PINK PLACES POOL POSITION POS_HIGH POS_LOW PRAGMAS PREC
          PRECOMPILED PREFERRED PRESERVING PRIMARY PRINT PRINT-CONTROL
          PRIORITY PRIVATE PROCEDURE PROCESS PROGRAM PROPERTY PROTECTED
          PROVIDE PUBLIC PUSH PUSHBUTTON PUT QUAN QUEUE-ONLY QUICKINFO
          RADIOBUTTON RAISE RAISING RANGE RANGES RAW RAWSTRING READ READ-ONLY
          READER RECEIVE RECEIVED RECEIVER RECEIVING RED REDEFINITION REDUCE
          REDUCED REF REFERENCE REFRESH REGEX REJECT REMOTE RENAMING REPLACE
          REPLACEMENT REPLACING REPORT REQUEST REQUESTED RESERVE RESET
          RESOLUTION RESPECTING RESPONSIBLE RESULT RESULTS RESUMABLE RESUME
          RETRY RETURN RETURNCODE RETURNING RETURNS RIGHT RIGHT-JUSTIFIED
          RIGHTPLUS RIGHTSPACE RISK RMC_COMMUNICATION_FAILURE
          RMC_INVALID_STATUS RMC_SYSTEM_FAILURE ROLE ROLLBACK ROUND ROWS RPAD
          RTRIM RUN SAP SAP-SPOOL SAVING SCALE_PRESERVING
          SCALE_PRESERVING_SCIENTIFIC SCAN SCIENTIFIC
          SCIENTIFIC_WITH_LEADING_ZERO SCREEN SCROLL SCROLL-BOUNDARY SCROLLING
          SEARCH SECONDARY SECONDS SECTION SELECT SELECT-OPTIONS SELECTION
          SELECTION-SCREEN SELECTION-SET SELECTION-SETS SELECTION-TABLE
          SELECTIONS SEND SEPARATE SEPARATED SET SHARED SHIFT SHORT
          SHORTDUMP-ID SIGN SIGN_AS_POSTFIX SIMPLE SINGLE SIZE SKIP SKIPPING
          SMART SOME SORT SORTABLE SORTED SOURCE SPACE SPECIFIED SPLIT SPOOL
          SPOTS SQL SQLSCRIPT SSTRING STABLE STAMP STANDARD START-OF-SELECTION
          STARTING STATE STATEMENT STATEMENTS STATIC STATICS STATUSINFO
          STEP-LOOP STOP STRING STRUCTURE STRUCTURES STYLE SUBKEY SUBMATCHES
          SUBMIT SUBROUTINE SUBSCREEN SUBSTRING SUBTRACT
          SUBTRACT-CORRESPONDING SUFFIX SUM SUMMARY SUMMING SUPPLIED SUPPLY
          SUPPRESS SWITCH SWITCHSTATES SYMBOL SYNCPOINTS SYNTAX SYNTAX-CHECK
          SYNTAX-TRACE SYST SYSTEM-CALL SYSTEM-EXCEPTIONS SYSTEM-EXIT TAB
          TABBED TABLE TABLES TABLEVIEW TABSTRIP TARGET TASK TASKS TEST
          TEST-INJECTION TEST-SEAM TESTING TEXT TEXTPOOL THEN THROW TIME TIMES
          TIMESTAMP TIMEZONE TIMS TIMS_IS_VALID TITLE TITLE-LINES TITLEBAR TO
          TOKENIZATION TOKENS TOP-LINES TOP-OF-PAGE TRACE-FILE TRACE-TABLE
          TRAILING TRANSACTION TRANSFER TRANSFORMATION TRANSLATE TRANSPORTING
          TRMAC TRUNCATE TRUNCATION TRY TSTMP_ADD_SECONDS
          TSTMP_CURRENT_UTCTIMESTAMP TSTMP_IS_VALID TSTMP_SECONDS_BETWEEN TYPE
          TYPE-POOL TYPE-POOLS TYPES ULINE UNASSIGN UNDER UNICODE UNION UNIQUE
          UNIT UNIT_CONVERSION UNIX UNPACK UNTIL UNWIND UP UPDATE UPPER USER
          USER-COMMAND USING UTF-8 VALID VALUE VALUE-REQUEST VALUES VARC VARY
          VARYING VERIFICATION-MESSAGE VERSION VIA VIEW VISIBLE WAIT WARNING
          WHEN WHENEVER WHERE WHILE WIDTH WINDOW WINDOWS WITH WITH-HEADING
          WITH-TITLE WITHOUT WORD WORK WRITE WRITER XML XSD YELLOW YES YYMMDD
          Z ZERO ZONE
        )
      end

      def self.builtins
        @keywords = Set.new %w(
          acos apply asin assign atan attribute bit-set boolc boolx call
          call-method cast ceil cfunc charlen char_off class_constructor clear
          cluster cmax cmin cnt communication_failure concat_lines_of cond
          cond-var condense constructor contains contains_any_not_of
          contains_any_of copy cos cosh count count_any_not_of count_any_of
          create cursor data dbmaxlen dbtab deserialize destructor distance
          empty error_message escape exp extensible find find_any_not_of
          find_any_of find_end floor frac from_mixed group hashed header idx
          include index insert ipow itab key lax lines line_exists line_index
          log log10 loop loop_key match matches me mesh_path namespace nmax
          nmin node numeric numofchar object parameter primary_key read ref
          repeat replace rescale resource_failure reverse root round segment
          sender serialize shift_left shift_right sign simple sin sinh skip
          sorted space sqrt standard strlen substring substring_after
          substring_before substring_from substring_to sum switch switch-var
          system_failure table table_line tan tanh template text to_lower
          to_mixed to_upper transform translate trunc type value variable write
          xsdbool xsequence xstrlen
        )
      end

      def self.types
        @types = Set.new %w(
         b c d decfloat16 decfloat34 f i int8 n p s t x
         clike csequence decfloat string xstring
        )
      end

      def self.new_keywords
        @types = Set.new %w(
          DATA FIELD-SYMBOL
        )
      end

      state :root do
        rule /\s+/m, Text

        rule /".*/, Comment::Single
        rule %r(^\*.*), Comment::Multiline
        rule /\d+/, Num::Integer
        rule /('|`)/, Str::Single, :single_string
        rule /[\[\]\(\)\{\}\[\]\.,:\|]/, Punctuation

        # builtins / new ABAP 7.40 keywords (@DATA(), ...)
        rule /(->|=>)?([A-Za-z][A-Za-z0-9_\-]*)(\()/ do |m|
          if m[1] != ''
            token Operator, m[1]
          end

          if (self.class.new_keywords.include? m[2].upcase) && m[1].nil?
            token Keyword, m[2]
          elsif (self.class.builtins.include? m[2].downcase) && m[1].nil?
            token Name::Builtin, m[2]
          else
            token Name, m[2]
          end
          token Punctuation, m[3]
        end

        # keywords, types and normal text
        rule /\w[\w\d]*/ do |m|
          if self.class.keywords.include? m[0].upcase
            token Keyword
          elsif self.class.types.include? m[0].downcase
            token Keyword::Type
          else
            token Name
          end
        end

        # operators
        rule %r((->|->>|=>)), Operator
        rule %r([-\*\+%/~=&\?<>!#\@\^]+), Operator

      end

      state :operators do
        rule %r((->|->>|=>)), Operator
        rule %r([-\*\+%/~=&\?<>!#\@\^]+), Operator
      end

      state :single_string do
        rule /\\./, Str::Escape
        rule /(''|``)/, Str::Escape
        rule /['`]/, Str::Single, :pop!
        rule /[^\\'`]+/, Str::Single
      end

    end
  end
end
