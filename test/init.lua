--
-- Created by: Cyril.
-- Created at: 15/6/21 上午2:05
-- Email: houshoushuai@gmail.com
--

local Mongo = require("../")
local Bit64 = Mongo.Bit64
local Bit32 = Mongo.Bit32
local Date = Mongo.Date
local ObjectId = Mongo.ObjectId

m = Mongo:new({db = "test"})

m:on("connect", function()
    m:insert("abc", {name = "a", age = 2}, nil, function(res)
        local _id = res[1]._id
        m:find("abc", {_id = res[1]._id}, nil, nil, nil, function(res)
            if assert(#res == 1, "Should be 1") then
                p(res)
                p("Insert Pass!")
            end
            m:update("abc", {_id = _id}, {["$set"] = {height = "Hello World!"}}, true, nil,function(ures)
                p(ures, "xxx")
                m:find("abc", {_id = _id}, nil, nil, nil, function(res)
                    if assert(res[1].height == "Hello World!", "Update faied") then
                        p("Update Passed!!!")
                        m:remove("abc", {_id = _id}, nil, function()
                            p("Deleted")
                            m:count("abc", {_id = _id}, function(res)
                                if assert(res == 0, "Should be 0") then
                                    p("Remove and count pass!")
                                end
                            end)
                        end)
                    end
                end)
            end)
        end)
    end)

    m:insert("abc", {content = [[--
    <div class="blob-wrapper data type-lua">
      <table class="highlight tab-size js-file-line-container" data-tab-size="8">
      <tbody><tr>
        <td id="L1" class="blob-num js-line-number" data-line-number="1"></td>
        <td id="LC1" class="blob-code blob-code-inner js-file-line"><span class="pl-c">--</span></td>
      </tr>
      <tr>
        <td id="L2" class="blob-num js-line-number" data-line-number="2"></td>
        <td id="LC2" class="blob-code blob-code-inner js-file-line"><span class="pl-c">-- Created by: Cyril.</span></td>
      </tr>
      <tr>
        <td id="L3" class="blob-num js-line-number" data-line-number="3"></td>
        <td id="LC3" class="blob-code blob-code-inner js-file-line"><span class="pl-c">-- Created at: 15/6/20 上午12:18</span></td>
      </tr>
      <tr>
        <td id="L4" class="blob-num js-line-number" data-line-number="4"></td>
        <td id="LC4" class="blob-code blob-code-inner js-file-line"><span class="pl-c">-- Email: houshoushuai@gmail.com</span></td>
      </tr>
      <tr>
        <td id="L5" class="blob-num js-line-number" data-line-number="5"></td>
        <td id="LC5" class="blob-code blob-code-inner js-file-line"><span class="pl-c">--</span></td>
      </tr>
      <tr>
        <td id="L6" class="blob-num js-line-number" data-line-number="6"></td>
        <td id="LC6" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L7" class="blob-num js-line-number" data-line-number="7"></td>
        <td id="LC7" class="blob-code blob-code-inner js-file-line">Emitter <span class="pl-k">=</span> <span class="pl-c1">require</span>(<span class="pl-s"><span class="pl-pds">'</span>core<span class="pl-pds">'</span></span>).<span class="pl-smi">Emitter</span></td>
      </tr>
      <tr>
        <td id="L8" class="blob-num js-line-number" data-line-number="8"></td>
        <td id="LC8" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> net <span class="pl-k">=</span> <span class="pl-c1">require</span>(<span class="pl-s"><span class="pl-pds">"</span>net<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L9" class="blob-num js-line-number" data-line-number="9"></td>
        <td id="LC9" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> ll <span class="pl-k">=</span> <span class="pl-c1">require</span> ( <span class="pl-s"><span class="pl-pds">"</span>./utils<span class="pl-pds">"</span></span> )</td>
      </tr>
      <tr>
        <td id="L10" class="blob-num js-line-number" data-line-number="10"></td>
        <td id="LC10" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> num_to_le_uint <span class="pl-k">=</span> ll.<span class="pl-smi">num_to_le_uint</span></td>
      </tr>
      <tr>
        <td id="L11" class="blob-num js-line-number" data-line-number="11"></td>
        <td id="LC11" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> num_to_le_int <span class="pl-k">=</span> ll.<span class="pl-smi">num_to_le_int</span></td>
      </tr>
      <tr>
        <td id="L12" class="blob-num js-line-number" data-line-number="12"></td>
        <td id="LC12" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> le_uint_to_num <span class="pl-k">=</span> ll.<span class="pl-smi">le_uint_to_num</span></td>
      </tr>
      <tr>
        <td id="L13" class="blob-num js-line-number" data-line-number="13"></td>
        <td id="LC13" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> le_bpeek <span class="pl-k">=</span> ll.<span class="pl-smi">le_bpeek</span></td>
      </tr>
      <tr>
        <td id="L14" class="blob-num js-line-number" data-line-number="14"></td>
        <td id="LC14" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> bson <span class="pl-k">=</span> <span class="pl-c1">require</span>(<span class="pl-s"><span class="pl-pds">"</span>./bson<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L15" class="blob-num js-line-number" data-line-number="15"></td>
        <td id="LC15" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> to_bson <span class="pl-k">=</span> bson.<span class="pl-smi">to_bson</span></td>
      </tr>
      <tr>
        <td id="L16" class="blob-num js-line-number" data-line-number="16"></td>
        <td id="LC16" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> from_bson <span class="pl-k">=</span> bson.<span class="pl-smi">from_bson</span></td>
      </tr>
      <tr>
        <td id="L17" class="blob-num js-line-number" data-line-number="17"></td>
        <td id="LC17" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L18" class="blob-num js-line-number" data-line-number="18"></td>
        <td id="LC18" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> getlib <span class="pl-k">=</span> <span class="pl-c1">require</span> ( <span class="pl-s"><span class="pl-pds">"</span>./get<span class="pl-pds">"</span></span> )</td>
      </tr>
      <tr>
        <td id="L19" class="blob-num js-line-number" data-line-number="19"></td>
        <td id="LC19" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> get_from_string <span class="pl-k">=</span> getlib.<span class="pl-smi">get_from_string</span></td>
      </tr>
      <tr>
        <td id="L20" class="blob-num js-line-number" data-line-number="20"></td>
        <td id="LC20" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> ObjectId <span class="pl-k">=</span> <span class="pl-c1">require</span> <span class="pl-s"><span class="pl-pds">"</span>./objectId<span class="pl-pds">"</span></span></td>
      </tr>
      <tr>
        <td id="L21" class="blob-num js-line-number" data-line-number="21"></td>
        <td id="LC21" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L22" class="blob-num js-line-number" data-line-number="22"></td>
        <td id="LC22" class="blob-code blob-code-inner js-file-line">Mongo <span class="pl-k">=</span> Emitter:<span class="pl-c1">extend</span>()</td>
      </tr>
      <tr>
        <td id="L23" class="blob-num js-line-number" data-line-number="23"></td>
        <td id="LC23" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L24" class="blob-num js-line-number" data-line-number="24"></td>
        <td id="LC24" class="blob-code blob-code-inner js-file-line">_id <span class="pl-k">=</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L25" class="blob-num js-line-number" data-line-number="25"></td>
        <td id="LC25" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">initialize</span>(<span class="pl-smi">options</span>)</td>
      </tr>
      <tr>
        <td id="L26" class="blob-num js-line-number" data-line-number="26"></td>
        <td id="LC26" class="blob-code blob-code-inner js-file-line">    options <span class="pl-k">=</span> options <span class="pl-k">or</span> {}</td>
      </tr>
      <tr>
        <td id="L27" class="blob-num js-line-number" data-line-number="27"></td>
        <td id="LC27" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">options</span> <span class="pl-k">=</span> options</td>
      </tr>
      <tr>
        <td id="L28" class="blob-num js-line-number" data-line-number="28"></td>
        <td id="LC28" class="blob-code blob-code-inner js-file-line">    _id <span class="pl-k">=</span> _id <span class="pl-k">+</span> <span class="pl-c1">1</span></td>
      </tr>
      <tr>
        <td id="L29" class="blob-num js-line-number" data-line-number="29"></td>
        <td id="LC29" class="blob-code blob-code-inner js-file-line">    <span class="pl-c1">p</span>(<span class="pl-s"><span class="pl-pds">"</span>[Info] - Create connection.......<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L30" class="blob-num js-line-number" data-line-number="30"></td>
        <td id="LC30" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">port</span> <span class="pl-k">=</span> options.<span class="pl-smi">port</span> <span class="pl-k">or</span> <span class="pl-c1">27017</span></td>
      </tr>
      <tr>
        <td id="L31" class="blob-num js-line-number" data-line-number="31"></td>
        <td id="LC31" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">host</span> <span class="pl-k">=</span> options.<span class="pl-smi">host</span> <span class="pl-k">or</span> <span class="pl-s"><span class="pl-pds">'</span>127.0.0.1<span class="pl-pds">'</span></span></td>
      </tr>
      <tr>
        <td id="L32" class="blob-num js-line-number" data-line-number="32"></td>
        <td id="LC32" class="blob-code blob-code-inner js-file-line">    <span class="pl-c1">assert</span>(options.<span class="pl-smi">db</span> <span class="pl-k">or</span> options.<span class="pl-smi">dbname</span>, <span class="pl-s"><span class="pl-pds">"</span>Should specify a database name.<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L33" class="blob-num js-line-number" data-line-number="33"></td>
        <td id="LC33" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">db</span> <span class="pl-k">=</span> options.<span class="pl-smi">db</span> <span class="pl-k">or</span> options.<span class="pl-smi">dbname</span></td>
      </tr>
      <tr>
        <td id="L34" class="blob-num js-line-number" data-line-number="34"></td>
        <td id="LC34" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">requestId</span> <span class="pl-k">=</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L35" class="blob-num js-line-number" data-line-number="35"></td>
        <td id="LC35" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">queues</span> <span class="pl-k">=</span> {}</td>
      </tr>
      <tr>
        <td id="L36" class="blob-num js-line-number" data-line-number="36"></td>
        <td id="LC36" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span> <span class="pl-k">=</span> {}</td>
      </tr>
      <tr>
        <td id="L37" class="blob-num js-line-number" data-line-number="37"></td>
        <td id="LC37" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">connect</span>()</td>
      </tr>
      <tr>
        <td id="L38" class="blob-num js-line-number" data-line-number="38"></td>
        <td id="LC38" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L39" class="blob-num js-line-number" data-line-number="39"></td>
        <td id="LC39" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L40" class="blob-num js-line-number" data-line-number="40"></td>
        <td id="LC40" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> opcodes <span class="pl-k">=</span> {</td>
      </tr>
      <tr>
        <td id="L41" class="blob-num js-line-number" data-line-number="41"></td>
        <td id="LC41" class="blob-code blob-code-inner js-file-line">    REPLY <span class="pl-k">=</span> <span class="pl-c1">1</span> ;</td>
      </tr>
      <tr>
        <td id="L42" class="blob-num js-line-number" data-line-number="42"></td>
        <td id="LC42" class="blob-code blob-code-inner js-file-line">    MSG <span class="pl-k">=</span> <span class="pl-c1">1000</span> ;</td>
      </tr>
      <tr>
        <td id="L43" class="blob-num js-line-number" data-line-number="43"></td>
        <td id="LC43" class="blob-code blob-code-inner js-file-line">    UPDATE <span class="pl-k">=</span> <span class="pl-c1">2001</span> ;</td>
      </tr>
      <tr>
        <td id="L44" class="blob-num js-line-number" data-line-number="44"></td>
        <td id="LC44" class="blob-code blob-code-inner js-file-line">    INSERT <span class="pl-k">=</span> <span class="pl-c1">2002</span> ;</td>
      </tr>
      <tr>
        <td id="L45" class="blob-num js-line-number" data-line-number="45"></td>
        <td id="LC45" class="blob-code blob-code-inner js-file-line">    QUERY <span class="pl-k">=</span> <span class="pl-c1">2004</span> ;</td>
      </tr>
      <tr>
        <td id="L46" class="blob-num js-line-number" data-line-number="46"></td>
        <td id="LC46" class="blob-code blob-code-inner js-file-line">    GET_MORE <span class="pl-k">=</span> <span class="pl-c1">2005</span> ;</td>
      </tr>
      <tr>
        <td id="L47" class="blob-num js-line-number" data-line-number="47"></td>
        <td id="LC47" class="blob-code blob-code-inner js-file-line">    DELETE <span class="pl-k">=</span> <span class="pl-c1">2006</span> ;</td>
      </tr>
      <tr>
        <td id="L48" class="blob-num js-line-number" data-line-number="48"></td>
        <td id="LC48" class="blob-code blob-code-inner js-file-line">    KILL_CURSORS <span class="pl-k">=</span> <span class="pl-c1">2007</span> ;</td>
      </tr>
      <tr>
        <td id="L49" class="blob-num js-line-number" data-line-number="49"></td>
        <td id="LC49" class="blob-code blob-code-inner js-file-line">}</td>
      </tr>
      <tr>
        <td id="L50" class="blob-num js-line-number" data-line-number="50"></td>
        <td id="LC50" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L51" class="blob-num js-line-number" data-line-number="51"></td>
        <td id="LC51" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> <span class="pl-k">function</span> <span class="pl-en">compose_msg</span> (<span class="pl-smi">requestId ,reponseTo , opcode , message </span>)</td>
      </tr>
      <tr>
        <td id="L52" class="blob-num js-line-number" data-line-number="52"></td>
        <td id="LC52" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> requestID <span class="pl-k">=</span> <span class="pl-c1">num_to_le_uint</span>(requestId)</td>
      </tr>
      <tr>
        <td id="L53" class="blob-num js-line-number" data-line-number="53"></td>
        <td id="LC53" class="blob-code blob-code-inner js-file-line">    reponseTo <span class="pl-k">=</span> reponseTo <span class="pl-k">or</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-cce">\2</span>55<span class="pl-cce">\2</span>55<span class="pl-cce">\2</span>55<span class="pl-cce">\2</span>55<span class="pl-pds">"</span></span></td>
      </tr>
      <tr>
        <td id="L54" class="blob-num js-line-number" data-line-number="54"></td>
        <td id="LC54" class="blob-code blob-code-inner js-file-line">    opcode <span class="pl-k">=</span> <span class="pl-c1">num_to_le_uint</span> ( <span class="pl-c1">assert</span> ( opcodes [ opcode ] ) )</td>
      </tr>
      <tr>
        <td id="L55" class="blob-num js-line-number" data-line-number="55"></td>
        <td id="LC55" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> <span class="pl-c1">num_to_le_uint</span> ( <span class="pl-k">#</span>message <span class="pl-k">+</span> <span class="pl-c1">16</span> ) <span class="pl-k">..</span> requestID <span class="pl-k">..</span> reponseTo <span class="pl-k">..</span> opcode <span class="pl-k">..</span> message</td>
      </tr>
      <tr>
        <td id="L56" class="blob-num js-line-number" data-line-number="56"></td>
        <td id="LC56" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L57" class="blob-num js-line-number" data-line-number="57"></td>
        <td id="LC57" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L58" class="blob-num js-line-number" data-line-number="58"></td>
        <td id="LC58" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> <span class="pl-k">function</span> <span class="pl-en">getCollectionName</span> (<span class="pl-smi">self, collection</span>)</td>
      </tr>
      <tr>
        <td id="L59" class="blob-num js-line-number" data-line-number="59"></td>
        <td id="LC59" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> db <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">db</span></td>
      </tr>
      <tr>
        <td id="L60" class="blob-num js-line-number" data-line-number="60"></td>
        <td id="LC60" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span>  db <span class="pl-k">..</span> <span class="pl-s"><span class="pl-pds">"</span>.<span class="pl-pds">"</span></span> <span class="pl-k">..</span> collection <span class="pl-k">..</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-cce">\0</span><span class="pl-pds">"</span></span></td>
      </tr>
      <tr>
        <td id="L61" class="blob-num js-line-number" data-line-number="61"></td>
        <td id="LC61" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L62" class="blob-num js-line-number" data-line-number="62"></td>
        <td id="LC62" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L63" class="blob-num js-line-number" data-line-number="63"></td>
        <td id="LC63" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> <span class="pl-k">function</span> <span class="pl-en">read_msg_header</span> (<span class="pl-smi"> data </span>)</td>
      </tr>
      <tr>
        <td id="L64" class="blob-num js-line-number" data-line-number="64"></td>
        <td id="LC64" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> header <span class="pl-k">=</span> <span class="pl-c1">assert</span> ( <span class="pl-c1">get_from_string</span> ( data )(<span class="pl-c1">16</span>) )</td>
      </tr>
      <tr>
        <td id="L65" class="blob-num js-line-number" data-line-number="65"></td>
        <td id="LC65" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> length <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span> ( header , <span class="pl-c1">1</span> , <span class="pl-c1">4</span> )</td>
      </tr>
      <tr>
        <td id="L66" class="blob-num js-line-number" data-line-number="66"></td>
        <td id="LC66" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> requestID <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span> ( header , <span class="pl-c1">5</span> , <span class="pl-c1">8</span> )</td>
      </tr>
      <tr>
        <td id="L67" class="blob-num js-line-number" data-line-number="67"></td>
        <td id="LC67" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> reponseTo <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span> ( header , <span class="pl-c1">9</span> , <span class="pl-c1">12</span> )</td>
      </tr>
      <tr>
        <td id="L68" class="blob-num js-line-number" data-line-number="68"></td>
        <td id="LC68" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> opcode <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span> ( header , <span class="pl-c1">13</span> , <span class="pl-c1">16</span> )</td>
      </tr>
      <tr>
        <td id="L69" class="blob-num js-line-number" data-line-number="69"></td>
        <td id="LC69" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> length , requestID , reponseTo , opcode</td>
      </tr>
      <tr>
        <td id="L70" class="blob-num js-line-number" data-line-number="70"></td>
        <td id="LC70" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L71" class="blob-num js-line-number" data-line-number="71"></td>
        <td id="LC71" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L72" class="blob-num js-line-number" data-line-number="72"></td>
        <td id="LC72" class="blob-code blob-code-inner js-file-line"><span class="pl-k">local</span> <span class="pl-k">function</span> <span class="pl-en">parseData</span> (<span class="pl-smi"> data </span>)</td>
      </tr>
      <tr>
        <td id="L73" class="blob-num js-line-number" data-line-number="73"></td>
        <td id="LC73" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L74" class="blob-num js-line-number" data-line-number="74"></td>
        <td id="LC74" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> offset_i <span class="pl-k">=</span>  <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L75" class="blob-num js-line-number" data-line-number="75"></td>
        <td id="LC75" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L76" class="blob-num js-line-number" data-line-number="76"></td>
        <td id="LC76" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> r_len , r_req_id , resId , opcode <span class="pl-k">=</span> <span class="pl-c1">read_msg_header</span> ( data )</td>
      </tr>
      <tr>
        <td id="L77" class="blob-num js-line-number" data-line-number="77"></td>
        <td id="LC77" class="blob-code blob-code-inner js-file-line">    <span class="pl-c">--assert ( req_id == r_res_id )</span></td>
      </tr>
      <tr>
        <td id="L78" class="blob-num js-line-number" data-line-number="78"></td>
        <td id="LC78" class="blob-code blob-code-inner js-file-line">    <span class="pl-c1">assert</span> ( opcode <span class="pl-k">==</span> opcodes.<span class="pl-smi">REPLY</span> )</td>
      </tr>
      <tr>
        <td id="L79" class="blob-num js-line-number" data-line-number="79"></td>
        <td id="LC79" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> data <span class="pl-k">=</span> <span class="pl-c1">assert</span> ( data )</td>
      </tr>
      <tr>
        <td id="L80" class="blob-num js-line-number" data-line-number="80"></td>
        <td id="LC80" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> get <span class="pl-k">=</span> <span class="pl-c1">get_from_string</span> ( data )</td>
      </tr>
      <tr>
        <td id="L81" class="blob-num js-line-number" data-line-number="81"></td>
        <td id="LC81" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> abadon <span class="pl-k">=</span> <span class="pl-c1">get</span>(<span class="pl-c1">16</span>)</td>
      </tr>
      <tr>
        <td id="L82" class="blob-num js-line-number" data-line-number="82"></td>
        <td id="LC82" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> responseFlags <span class="pl-k">=</span> <span class="pl-c1">get</span> ( <span class="pl-c1">4</span> )</td>
      </tr>
      <tr>
        <td id="L83" class="blob-num js-line-number" data-line-number="83"></td>
        <td id="LC83" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> cursorId <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span>(<span class="pl-c1">get</span> ( <span class="pl-c1">8</span> ))</td>
      </tr>
      <tr>
        <td id="L84" class="blob-num js-line-number" data-line-number="84"></td>
        <td id="LC84" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L85" class="blob-num js-line-number" data-line-number="85"></td>
        <td id="LC85" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> tags <span class="pl-k">=</span> { }</td>
      </tr>
      <tr>
        <td id="L86" class="blob-num js-line-number" data-line-number="86"></td>
        <td id="LC86" class="blob-code blob-code-inner js-file-line">    tags.<span class="pl-smi">startingFrom</span> <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span> ( <span class="pl-c1">get</span> ( <span class="pl-c1">4</span> ) )</td>
      </tr>
      <tr>
        <td id="L87" class="blob-num js-line-number" data-line-number="87"></td>
        <td id="LC87" class="blob-code blob-code-inner js-file-line">    tags.<span class="pl-smi">numberReturned</span> <span class="pl-k">=</span> <span class="pl-c1">le_uint_to_num</span> ( <span class="pl-c1">get</span> ( <span class="pl-c1">4</span> ) )</td>
      </tr>
      <tr>
        <td id="L88" class="blob-num js-line-number" data-line-number="88"></td>
        <td id="LC88" class="blob-code blob-code-inner js-file-line">    tags.<span class="pl-smi">CursorNotFound</span> <span class="pl-k">=</span> <span class="pl-c1">le_bpeek</span> ( responseFlags , <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L89" class="blob-num js-line-number" data-line-number="89"></td>
        <td id="LC89" class="blob-code blob-code-inner js-file-line">    tags.<span class="pl-smi">QueryFailure</span> <span class="pl-k">=</span> <span class="pl-c1">le_bpeek</span> ( responseFlags , <span class="pl-c1">1</span> )</td>
      </tr>
      <tr>
        <td id="L90" class="blob-num js-line-number" data-line-number="90"></td>
        <td id="LC90" class="blob-code blob-code-inner js-file-line">    tags.<span class="pl-smi">ShardConfigStale</span> <span class="pl-k">=</span> <span class="pl-c1">le_bpeek</span> ( responseFlags , <span class="pl-c1">2</span> )</td>
      </tr>
      <tr>
        <td id="L91" class="blob-num js-line-number" data-line-number="91"></td>
        <td id="LC91" class="blob-code blob-code-inner js-file-line">    tags.<span class="pl-smi">AwaitCapable</span> <span class="pl-k">=</span> <span class="pl-c1">le_bpeek</span> ( responseFlags , <span class="pl-c1">3</span> )</td>
      </tr>
      <tr>
        <td id="L92" class="blob-num js-line-number" data-line-number="92"></td>
        <td id="LC92" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L93" class="blob-num js-line-number" data-line-number="93"></td>
        <td id="LC93" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> res <span class="pl-k">=</span> {}</td>
      </tr>
      <tr>
        <td id="L94" class="blob-num js-line-number" data-line-number="94"></td>
        <td id="LC94" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">for</span> i <span class="pl-k">=</span> <span class="pl-c1">1</span> , tags.<span class="pl-smi">numberReturned</span> <span class="pl-k">do</span></td>
      </tr>
      <tr>
        <td id="L95" class="blob-num js-line-number" data-line-number="95"></td>
        <td id="LC95" class="blob-code blob-code-inner js-file-line">        res[ i <span class="pl-k">+</span> offset_i ] <span class="pl-k">=</span> <span class="pl-c1">from_bson</span> ( get )</td>
      </tr>
      <tr>
        <td id="L96" class="blob-num js-line-number" data-line-number="96"></td>
        <td id="LC96" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L97" class="blob-num js-line-number" data-line-number="97"></td>
        <td id="LC97" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> resId, cursorId , res, tags</td>
      </tr>
      <tr>
        <td id="L98" class="blob-num js-line-number" data-line-number="98"></td>
        <td id="LC98" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L99" class="blob-num js-line-number" data-line-number="99"></td>
        <td id="LC99" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L100" class="blob-num js-line-number" data-line-number="100"></td>
        <td id="LC100" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L101" class="blob-num js-line-number" data-line-number="101"></td>
        <td id="LC101" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">addCallback</span> (<span class="pl-smi">id, callback, ids, collection</span>)</td>
      </tr>
      <tr>
        <td id="L102" class="blob-num js-line-number" data-line-number="102"></td>
        <td id="LC102" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> <span class="pl-c1">type</span>(callback) <span class="pl-k">==</span> <span class="pl-s"><span class="pl-pds">"</span>function<span class="pl-pds">"</span></span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L103" class="blob-num js-line-number" data-line-number="103"></td>
        <td id="LC103" class="blob-code blob-code-inner js-file-line">        <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[id] <span class="pl-k">=</span> {callback <span class="pl-k">=</span> callback, ids <span class="pl-k">=</span> ids, collection <span class="pl-k">=</span> collection}</td>
      </tr>
      <tr>
        <td id="L104" class="blob-num js-line-number" data-line-number="104"></td>
        <td id="LC104" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L105" class="blob-num js-line-number" data-line-number="105"></td>
        <td id="LC105" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L106" class="blob-num js-line-number" data-line-number="106"></td>
        <td id="LC106" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L107" class="blob-num js-line-number" data-line-number="107"></td>
        <td id="LC107" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L108" class="blob-num js-line-number" data-line-number="108"></td>
        <td id="LC108" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">command</span> (<span class="pl-smi">opcode, message, callback, ids, collection</span>)</td>
      </tr>
      <tr>
        <td id="L109" class="blob-num js-line-number" data-line-number="109"></td>
        <td id="LC109" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> requestId <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">requestId</span> <span class="pl-k">+</span> <span class="pl-c1">1</span></td>
      </tr>
      <tr>
        <td id="L110" class="blob-num js-line-number" data-line-number="110"></td>
        <td id="LC110" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">requestId</span> <span class="pl-k">=</span> requestId</td>
      </tr>
      <tr>
        <td id="L111" class="blob-num js-line-number" data-line-number="111"></td>
        <td id="LC111" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> m <span class="pl-k">=</span> <span class="pl-c1">compose_msg</span>(requestId, <span class="pl-c1">nil</span>, opcode, message)</td>
      </tr>
      <tr>
        <td id="L112" class="blob-num js-line-number" data-line-number="112"></td>
        <td id="LC112" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">addCallback</span>(requestId, callback <span class="pl-k">or</span> <span class="pl-k">function</span>() <span class="pl-k">end</span>, ids, collection)</td>
      </tr>
      <tr>
        <td id="L113" class="blob-num js-line-number" data-line-number="113"></td>
        <td id="LC113" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">addQueue</span>(requestId, opcode, m)</td>
      </tr>
      <tr>
        <td id="L114" class="blob-num js-line-number" data-line-number="114"></td>
        <td id="LC114" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L115" class="blob-num js-line-number" data-line-number="115"></td>
        <td id="LC115" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L116" class="blob-num js-line-number" data-line-number="116"></td>
        <td id="LC116" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">addQueue</span>(<span class="pl-smi">requestId, opcode, m</span>)</td>
      </tr>
      <tr>
        <td id="L117" class="blob-num js-line-number" data-line-number="117"></td>
        <td id="LC117" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> queueLength <span class="pl-k">=</span> <span class="pl-k">#</span><span class="pl-v">self</span>.<span class="pl-smi">queues</span> <span class="pl-k">+</span> <span class="pl-c1">1</span></td>
      </tr>
      <tr>
        <td id="L118" class="blob-num js-line-number" data-line-number="118"></td>
        <td id="LC118" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">queues</span>[queueLength] <span class="pl-k">=</span> {message <span class="pl-k">=</span> m, requestId <span class="pl-k">=</span> requestId, opcode <span class="pl-k">=</span> opcode}</td>
      </tr>
      <tr>
        <td id="L119" class="blob-num js-line-number" data-line-number="119"></td>
        <td id="LC119" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> queueLength <span class="pl-k">==</span> <span class="pl-c1">1</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L120" class="blob-num js-line-number" data-line-number="120"></td>
        <td id="LC120" class="blob-code blob-code-inner js-file-line">        <span class="pl-v">self</span>:<span class="pl-c1">sendRequest</span>()</td>
      </tr>
      <tr>
        <td id="L121" class="blob-num js-line-number" data-line-number="121"></td>
        <td id="LC121" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L122" class="blob-num js-line-number" data-line-number="122"></td>
        <td id="LC122" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L123" class="blob-num js-line-number" data-line-number="123"></td>
        <td id="LC123" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L124" class="blob-num js-line-number" data-line-number="124"></td>
        <td id="LC124" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">sendRequest</span>()</td>
      </tr>
      <tr>
        <td id="L125" class="blob-num js-line-number" data-line-number="125"></td>
        <td id="LC125" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> <span class="pl-v">self</span>.<span class="pl-smi">queues</span>[<span class="pl-c1">1</span>] <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L126" class="blob-num js-line-number" data-line-number="126"></td>
        <td id="LC126" class="blob-code blob-code-inner js-file-line">        <span class="pl-v">self</span>.<span class="pl-smi">socket</span>:<span class="pl-c1">write</span>(<span class="pl-v">self</span>.<span class="pl-smi">queues</span>[<span class="pl-c1">1</span>][<span class="pl-s"><span class="pl-pds">"</span>message<span class="pl-pds">"</span></span>], <span class="pl-s"><span class="pl-pds">"</span>hex<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L127" class="blob-num js-line-number" data-line-number="127"></td>
        <td id="LC127" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">local</span> opcode <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">queues</span>[<span class="pl-c1">1</span>][<span class="pl-s"><span class="pl-pds">"</span>opcode<span class="pl-pds">"</span></span>]</td>
      </tr>
      <tr>
        <td id="L128" class="blob-num js-line-number" data-line-number="128"></td>
        <td id="LC128" class="blob-code blob-code-inner js-file-line">        <span class="pl-c">-- Insert Update, and Delete method has no response</span></td>
      </tr>
      <tr>
        <td id="L129" class="blob-num js-line-number" data-line-number="129"></td>
        <td id="LC129" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">if</span> opcode <span class="pl-k">==</span> <span class="pl-s"><span class="pl-pds">"</span>UPDATE<span class="pl-pds">"</span></span> <span class="pl-k">or</span> opcode <span class="pl-k">==</span> <span class="pl-s"><span class="pl-pds">"</span>INSERT<span class="pl-pds">"</span></span> <span class="pl-k">or</span> opcode <span class="pl-k">==</span> <span class="pl-s"><span class="pl-pds">"</span>DELETE<span class="pl-pds">"</span></span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L130" class="blob-num js-line-number" data-line-number="130"></td>
        <td id="LC130" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">local</span> requestId <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">queues</span>[<span class="pl-c1">1</span>][<span class="pl-s"><span class="pl-pds">"</span>requestId<span class="pl-pds">"</span></span>]</td>
      </tr>
      <tr>
        <td id="L131" class="blob-num js-line-number" data-line-number="131"></td>
        <td id="LC131" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">if</span> <span class="pl-k">not</span> <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[requestId].<span class="pl-smi">ids</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L132" class="blob-num js-line-number" data-line-number="132"></td>
        <td id="LC132" class="blob-code blob-code-inner js-file-line">                <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[requestId].<span class="pl-c1">callback</span>()</td>
      </tr>
      <tr>
        <td id="L133" class="blob-num js-line-number" data-line-number="133"></td>
        <td id="LC133" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L134" class="blob-num js-line-number" data-line-number="134"></td>
        <td id="LC134" class="blob-code blob-code-inner js-file-line"><span class="pl-c">--                self.callbacks[requestId].callback()</span></td>
      </tr>
      <tr>
        <td id="L135" class="blob-num js-line-number" data-line-number="135"></td>
        <td id="LC135" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">local</span> ids <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[requestId].<span class="pl-smi">ids</span></td>
      </tr>
      <tr>
        <td id="L136" class="blob-num js-line-number" data-line-number="136"></td>
        <td id="LC136" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">local</span> collection <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[requestId].<span class="pl-smi">collection</span></td>
      </tr>
      <tr>
        <td id="L137" class="blob-num js-line-number" data-line-number="137"></td>
        <td id="LC137" class="blob-code blob-code-inner js-file-line">                <span class="pl-v">self</span>:<span class="pl-c1">find</span>(collection, {_id <span class="pl-k">=</span> {[<span class="pl-s"><span class="pl-pds">"</span>$in<span class="pl-pds">"</span></span>] <span class="pl-k">=</span> ids}}, <span class="pl-c1">nil</span> , <span class="pl-c1">nil</span>, <span class="pl-c1">nil</span>, <span class="pl-k">function</span>(<span class="pl-smi">result</span>)</td>
      </tr>
      <tr>
        <td id="L138" class="blob-num js-line-number" data-line-number="138"></td>
        <td id="LC138" class="blob-code blob-code-inner js-file-line">                    <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[requestId].<span class="pl-c1">callback</span>(result)</td>
      </tr>
      <tr>
        <td id="L139" class="blob-num js-line-number" data-line-number="139"></td>
        <td id="LC139" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">end</span>)</td>
      </tr>
      <tr>
        <td id="L140" class="blob-num js-line-number" data-line-number="140"></td>
        <td id="LC140" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L141" class="blob-num js-line-number" data-line-number="141"></td>
        <td id="LC141" class="blob-code blob-code-inner js-file-line">            <span class="pl-c1">table.remove</span>(<span class="pl-v">self</span>.<span class="pl-smi">queues</span>, <span class="pl-c1">1</span>)</td>
      </tr>
      <tr>
        <td id="L142" class="blob-num js-line-number" data-line-number="142"></td>
        <td id="LC142" class="blob-code blob-code-inner js-file-line">            <span class="pl-v">self</span>:<span class="pl-c1">sendRequest</span>()</td>
      </tr>
      <tr>
        <td id="L143" class="blob-num js-line-number" data-line-number="143"></td>
        <td id="LC143" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L144" class="blob-num js-line-number" data-line-number="144"></td>
        <td id="LC144" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L145" class="blob-num js-line-number" data-line-number="145"></td>
        <td id="LC145" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L146" class="blob-num js-line-number" data-line-number="146"></td>
        <td id="LC146" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L147" class="blob-num js-line-number" data-line-number="147"></td>
        <td id="LC147" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">query</span> (<span class="pl-smi"> collection , query , fields , skip , limit , callback, options </span>)</td>
      </tr>
      <tr>
        <td id="L148" class="blob-num js-line-number" data-line-number="148"></td>
        <td id="LC148" class="blob-code blob-code-inner js-file-line">    skip <span class="pl-k">=</span> skip <span class="pl-k">or</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L149" class="blob-num js-line-number" data-line-number="149"></td>
        <td id="LC149" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> flags <span class="pl-k">=</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L150" class="blob-num js-line-number" data-line-number="150"></td>
        <td id="LC150" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> options <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L151" class="blob-num js-line-number" data-line-number="151"></td>
        <td id="LC151" class="blob-code blob-code-inner js-file-line">        flags <span class="pl-k">=</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">1</span><span class="pl-k">*</span>( options.<span class="pl-smi">TailableCursor</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L152" class="blob-num js-line-number" data-line-number="152"></td>
        <td id="LC152" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">2</span><span class="pl-k">*</span>( options.<span class="pl-smi">SlaveOk</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L153" class="blob-num js-line-number" data-line-number="153"></td>
        <td id="LC153" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">3</span><span class="pl-k">*</span>( options.<span class="pl-smi">OplogReplay</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L154" class="blob-num js-line-number" data-line-number="154"></td>
        <td id="LC154" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">4</span><span class="pl-k">*</span>( options.<span class="pl-smi">NoCursorTimeout</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L155" class="blob-num js-line-number" data-line-number="155"></td>
        <td id="LC155" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">5</span><span class="pl-k">*</span>( options.<span class="pl-smi">AwaitData</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L156" class="blob-num js-line-number" data-line-number="156"></td>
        <td id="LC156" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">6</span><span class="pl-k">*</span>( options.<span class="pl-smi">Exhaust</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L157" class="blob-num js-line-number" data-line-number="157"></td>
        <td id="LC157" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">7</span><span class="pl-k">*</span>( options.<span class="pl-smi">Partial</span> <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L158" class="blob-num js-line-number" data-line-number="158"></td>
        <td id="LC158" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L159" class="blob-num js-line-number" data-line-number="159"></td>
        <td id="LC159" class="blob-code blob-code-inner js-file-line">    query <span class="pl-k">=</span> <span class="pl-c1">to_bson</span>(query)</td>
      </tr>
      <tr>
        <td id="L160" class="blob-num js-line-number" data-line-number="160"></td>
        <td id="LC160" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> fields <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L161" class="blob-num js-line-number" data-line-number="161"></td>
        <td id="LC161" class="blob-code blob-code-inner js-file-line">        fields <span class="pl-k">=</span> <span class="pl-c1">to_bson</span>(fields)</td>
      </tr>
      <tr>
        <td id="L162" class="blob-num js-line-number" data-line-number="162"></td>
        <td id="LC162" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L163" class="blob-num js-line-number" data-line-number="163"></td>
        <td id="LC163" class="blob-code blob-code-inner js-file-line">        fields <span class="pl-k">=</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-pds">"</span></span></td>
      </tr>
      <tr>
        <td id="L164" class="blob-num js-line-number" data-line-number="164"></td>
        <td id="LC164" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L165" class="blob-num js-line-number" data-line-number="165"></td>
        <td id="LC165" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> m <span class="pl-k">=</span> <span class="pl-c1">num_to_le_uint</span> ( flags ) <span class="pl-k">..</span> <span class="pl-c1">getCollectionName</span> ( <span class="pl-v">self</span> , collection )</td>
      </tr>
      <tr>
        <td id="L166" class="blob-num js-line-number" data-line-number="166"></td>
        <td id="LC166" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">..</span> <span class="pl-c1">num_to_le_uint</span> ( skip ) <span class="pl-k">..</span> <span class="pl-c1">num_to_le_int</span> ( limit <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L167" class="blob-num js-line-number" data-line-number="167"></td>
        <td id="LC167" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">..</span> query <span class="pl-k">..</span> fields</td>
      </tr>
      <tr>
        <td id="L168" class="blob-num js-line-number" data-line-number="168"></td>
        <td id="LC168" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> requestId <span class="pl-k">=</span> <span class="pl-v">self</span>:<span class="pl-c1">command</span>(<span class="pl-s"><span class="pl-pds">"</span>QUERY<span class="pl-pds">"</span></span>, m, callback)</td>
      </tr>
      <tr>
        <td id="L169" class="blob-num js-line-number" data-line-number="169"></td>
        <td id="LC169" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L170" class="blob-num js-line-number" data-line-number="170"></td>
        <td id="LC170" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L171" class="blob-num js-line-number" data-line-number="171"></td>
        <td id="LC171" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">update</span> (<span class="pl-smi">collection, query, update, upsert, single, callback</span>)</td>
      </tr>
      <tr>
        <td id="L172" class="blob-num js-line-number" data-line-number="172"></td>
        <td id="LC172" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> flags <span class="pl-k">=</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">0</span><span class="pl-k">*</span>( upsert <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> ) <span class="pl-k">+</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">1</span><span class="pl-k">*</span>( single <span class="pl-k">and</span> <span class="pl-c1">0</span> <span class="pl-k">or</span> <span class="pl-c1">1</span> )</td>
      </tr>
      <tr>
        <td id="L173" class="blob-num js-line-number" data-line-number="173"></td>
        <td id="LC173" class="blob-code blob-code-inner js-file-line">    query <span class="pl-k">=</span> <span class="pl-c1">to_bson</span>(query)</td>
      </tr>
      <tr>
        <td id="L174" class="blob-num js-line-number" data-line-number="174"></td>
        <td id="LC174" class="blob-code blob-code-inner js-file-line">    update <span class="pl-k">=</span> <span class="pl-c1">to_bson</span>(update)</td>
      </tr>
      <tr>
        <td id="L175" class="blob-num js-line-number" data-line-number="175"></td>
        <td id="LC175" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> m <span class="pl-k">=</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-cce">\0\0\0\0</span><span class="pl-pds">"</span></span> <span class="pl-k">..</span> <span class="pl-c1">getCollectionName</span> ( <span class="pl-v">self</span> , collection ) <span class="pl-k">..</span> <span class="pl-c1">num_to_le_uint</span> ( flags ) <span class="pl-k">..</span> query <span class="pl-k">..</span> update</td>
      </tr>
      <tr>
        <td id="L176" class="blob-num js-line-number" data-line-number="176"></td>
        <td id="LC176" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">command</span>(<span class="pl-s"><span class="pl-pds">"</span>UPDATE<span class="pl-pds">"</span></span>, m, callback)</td>
      </tr>
      <tr>
        <td id="L177" class="blob-num js-line-number" data-line-number="177"></td>
        <td id="LC177" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L178" class="blob-num js-line-number" data-line-number="178"></td>
        <td id="LC178" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L179" class="blob-num js-line-number" data-line-number="179"></td>
        <td id="LC179" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">insert</span> (<span class="pl-smi">collection, docs, continue, callback</span>)</td>
      </tr>
      <tr>
        <td id="L180" class="blob-num js-line-number" data-line-number="180"></td>
        <td id="LC180" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> <span class="pl-k">not</span>(<span class="pl-k">#</span>docs <span class="pl-k">&gt;=</span> <span class="pl-c1">1</span>) <span class="pl-k">and</span> docs <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L181" class="blob-num js-line-number" data-line-number="181"></td>
        <td id="LC181" class="blob-code blob-code-inner js-file-line">        docs <span class="pl-k">=</span> {docs}</td>
      </tr>
      <tr>
        <td id="L182" class="blob-num js-line-number" data-line-number="182"></td>
        <td id="LC182" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L183" class="blob-num js-line-number" data-line-number="183"></td>
        <td id="LC183" class="blob-code blob-code-inner js-file-line">    <span class="pl-c1">assert</span>(<span class="pl-k">#</span>docs <span class="pl-k">&gt;=</span> <span class="pl-c1">1</span>)</td>
      </tr>
      <tr>
        <td id="L184" class="blob-num js-line-number" data-line-number="184"></td>
        <td id="LC184" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> flags <span class="pl-k">=</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">0</span><span class="pl-k">*</span>( continue <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L185" class="blob-num js-line-number" data-line-number="185"></td>
        <td id="LC185" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> t <span class="pl-k">=</span> {}</td>
      </tr>
      <tr>
        <td id="L186" class="blob-num js-line-number" data-line-number="186"></td>
        <td id="LC186" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> ids <span class="pl-k">=</span> {}</td>
      </tr>
      <tr>
        <td id="L187" class="blob-num js-line-number" data-line-number="187"></td>
        <td id="LC187" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">for</span> i , v <span class="pl-k">in</span> <span class="pl-c1">ipairs</span> ( docs ) <span class="pl-k">do</span></td>
      </tr>
      <tr>
        <td id="L188" class="blob-num js-line-number" data-line-number="188"></td>
        <td id="LC188" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">if</span> <span class="pl-k">not</span> v.<span class="pl-smi">_id</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L189" class="blob-num js-line-number" data-line-number="189"></td>
        <td id="LC189" class="blob-code blob-code-inner js-file-line">            v.<span class="pl-smi">_id</span> <span class="pl-k">=</span> ObjectId.<span class="pl-c1">new</span>()</td>
      </tr>
      <tr>
        <td id="L190" class="blob-num js-line-number" data-line-number="190"></td>
        <td id="LC190" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L191" class="blob-num js-line-number" data-line-number="191"></td>
        <td id="LC191" class="blob-code blob-code-inner js-file-line">        <span class="pl-c1">table.insert</span>(ids, v.<span class="pl-smi">_id</span>)</td>
      </tr>
      <tr>
        <td id="L192" class="blob-num js-line-number" data-line-number="192"></td>
        <td id="LC192" class="blob-code blob-code-inner js-file-line">        t [ i ] <span class="pl-k">=</span> <span class="pl-c1">to_bson</span> ( v )</td>
      </tr>
      <tr>
        <td id="L193" class="blob-num js-line-number" data-line-number="193"></td>
        <td id="LC193" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L194" class="blob-num js-line-number" data-line-number="194"></td>
        <td id="LC194" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> m <span class="pl-k">=</span> <span class="pl-c1">num_to_le_uint</span> ( flags ) <span class="pl-k">..</span> <span class="pl-c1">getCollectionName</span> ( <span class="pl-v">self</span> , collection ) <span class="pl-k">..</span> <span class="pl-c1">table.concat</span>( t )</td>
      </tr>
      <tr>
        <td id="L195" class="blob-num js-line-number" data-line-number="195"></td>
        <td id="LC195" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">command</span>(<span class="pl-s"><span class="pl-pds">"</span>INSERT<span class="pl-pds">"</span></span>, m, callback, ids, collection)</td>
      </tr>
      <tr>
        <td id="L196" class="blob-num js-line-number" data-line-number="196"></td>
        <td id="LC196" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L197" class="blob-num js-line-number" data-line-number="197"></td>
        <td id="LC197" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L198" class="blob-num js-line-number" data-line-number="198"></td>
        <td id="LC198" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">remove</span>(<span class="pl-smi">collection, query, singleRemove, callback</span>)</td>
      </tr>
      <tr>
        <td id="L199" class="blob-num js-line-number" data-line-number="199"></td>
        <td id="LC199" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> flags <span class="pl-k">=</span> <span class="pl-c1">2</span><span class="pl-k">^</span><span class="pl-c1">0</span><span class="pl-k">*</span>( singleRemove <span class="pl-k">and</span> <span class="pl-c1">1</span> <span class="pl-k">or</span> <span class="pl-c1">0</span> )</td>
      </tr>
      <tr>
        <td id="L200" class="blob-num js-line-number" data-line-number="200"></td>
        <td id="LC200" class="blob-code blob-code-inner js-file-line">    query <span class="pl-k">=</span> <span class="pl-c1">to_bson</span>(query)</td>
      </tr>
      <tr>
        <td id="L201" class="blob-num js-line-number" data-line-number="201"></td>
        <td id="LC201" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> m <span class="pl-k">=</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-cce">\0\0\0\0</span><span class="pl-pds">"</span></span> <span class="pl-k">..</span> <span class="pl-c1">getCollectionName</span> ( <span class="pl-v">self</span> , collection ) <span class="pl-k">..</span> <span class="pl-c1">num_to_le_uint</span> ( flags ) <span class="pl-k">..</span> query</td>
      </tr>
      <tr>
        <td id="L202" class="blob-num js-line-number" data-line-number="202"></td>
        <td id="LC202" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">command</span>(<span class="pl-s"><span class="pl-pds">"</span>DELETE<span class="pl-pds">"</span></span>, m, callback)</td>
      </tr>
      <tr>
        <td id="L203" class="blob-num js-line-number" data-line-number="203"></td>
        <td id="LC203" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L204" class="blob-num js-line-number" data-line-number="204"></td>
        <td id="LC204" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L205" class="blob-num js-line-number" data-line-number="205"></td>
        <td id="LC205" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">findOne</span>(<span class="pl-smi">collection, query, fields, skip,  cb</span>)</td>
      </tr>
      <tr>
        <td id="L206" class="blob-num js-line-number" data-line-number="206"></td>
        <td id="LC206" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> <span class="pl-k">function</span> <span class="pl-en">callback</span> (<span class="pl-smi">res</span>)</td>
      </tr>
      <tr>
        <td id="L207" class="blob-num js-line-number" data-line-number="207"></td>
        <td id="LC207" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">if</span> res <span class="pl-k">and</span>  <span class="pl-k">#</span>res <span class="pl-k">&gt;=</span> <span class="pl-c1">1</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L208" class="blob-num js-line-number" data-line-number="208"></td>
        <td id="LC208" class="blob-code blob-code-inner js-file-line">            <span class="pl-c1">cb</span>(res[<span class="pl-c1">1</span>])</td>
      </tr>
      <tr>
        <td id="L209" class="blob-num js-line-number" data-line-number="209"></td>
        <td id="LC209" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L210" class="blob-num js-line-number" data-line-number="210"></td>
        <td id="LC210" class="blob-code blob-code-inner js-file-line">            <span class="pl-c1">cb</span>(<span class="pl-c1">nil</span>)</td>
      </tr>
      <tr>
        <td id="L211" class="blob-num js-line-number" data-line-number="211"></td>
        <td id="LC211" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L212" class="blob-num js-line-number" data-line-number="212"></td>
        <td id="LC212" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L213" class="blob-num js-line-number" data-line-number="213"></td>
        <td id="LC213" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">query</span>(collection, query, fields, skip, <span class="pl-c1">1</span>, callback)</td>
      </tr>
      <tr>
        <td id="L214" class="blob-num js-line-number" data-line-number="214"></td>
        <td id="LC214" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L215" class="blob-num js-line-number" data-line-number="215"></td>
        <td id="LC215" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L216" class="blob-num js-line-number" data-line-number="216"></td>
        <td id="LC216" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">find</span>(<span class="pl-smi">collection, query, fields, skip, limit, callback</span>)</td>
      </tr>
      <tr>
        <td id="L217" class="blob-num js-line-number" data-line-number="217"></td>
        <td id="LC217" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">query</span>(collection, query, fields, skip, limit, callback)</td>
      </tr>
      <tr>
        <td id="L218" class="blob-num js-line-number" data-line-number="218"></td>
        <td id="LC218" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L219" class="blob-num js-line-number" data-line-number="219"></td>
        <td id="LC219" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L220" class="blob-num js-line-number" data-line-number="220"></td>
        <td id="LC220" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">count</span>(<span class="pl-smi">collection, query, callback</span>)</td>
      </tr>
      <tr>
        <td id="L221" class="blob-num js-line-number" data-line-number="221"></td>
        <td id="LC221" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> <span class="pl-k">function</span> <span class="pl-en">cb</span>(<span class="pl-smi">r</span>)</td>
      </tr>
      <tr>
        <td id="L222" class="blob-num js-line-number" data-line-number="222"></td>
        <td id="LC222" class="blob-code blob-code-inner js-file-line">        <span class="pl-c1">callback</span>(<span class="pl-k">#</span>r)</td>
      </tr>
      <tr>
        <td id="L223" class="blob-num js-line-number" data-line-number="223"></td>
        <td id="LC223" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L224" class="blob-num js-line-number" data-line-number="224"></td>
        <td id="LC224" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>:<span class="pl-c1">query</span>(collection, query, <span class="pl-c1">nil</span>, <span class="pl-c1">nil</span>, <span class="pl-c1">nil</span>, cb)</td>
      </tr>
      <tr>
        <td id="L225" class="blob-num js-line-number" data-line-number="225"></td>
        <td id="LC225" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L226" class="blob-num js-line-number" data-line-number="226"></td>
        <td id="LC226" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L227" class="blob-num js-line-number" data-line-number="227"></td>
        <td id="LC227" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L228" class="blob-num js-line-number" data-line-number="228"></td>
        <td id="LC228" class="blob-code blob-code-inner js-file-line"><span class="pl-k">function</span> <span class="pl-en">Mongo:</span><span class="pl-en">connect</span>()</td>
      </tr>
      <tr>
        <td id="L229" class="blob-num js-line-number" data-line-number="229"></td>
        <td id="LC229" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">local</span> socket</td>
      </tr>
      <tr>
        <td id="L230" class="blob-num js-line-number" data-line-number="230"></td>
        <td id="LC230" class="blob-code blob-code-inner js-file-line">    socket <span class="pl-k">=</span> net.<span class="pl-c1">createConnection</span>(<span class="pl-v">self</span>.<span class="pl-smi">port</span>, <span class="pl-v">self</span>.<span class="pl-smi">host</span>)</td>
      </tr>
      <tr>
        <td id="L231" class="blob-num js-line-number" data-line-number="231"></td>
        <td id="LC231" class="blob-code blob-code-inner js-file-line">    socket:<span class="pl-c1">on</span>(<span class="pl-s"><span class="pl-pds">"</span>connect<span class="pl-pds">"</span></span>, <span class="pl-k">function</span>()</td>
      </tr>
      <tr>
        <td id="L232" class="blob-num js-line-number" data-line-number="232"></td>
        <td id="LC232" class="blob-code blob-code-inner js-file-line">        <span class="pl-c1">p</span>(<span class="pl-s"><span class="pl-pds">"</span>[Info] - Database is connected.......<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L233" class="blob-num js-line-number" data-line-number="233"></td>
        <td id="LC233" class="blob-code blob-code-inner js-file-line">        <span class="pl-v">self</span>.<span class="pl-smi">tempData</span> <span class="pl-k">=</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-pds">"</span></span></td>
      </tr>
      <tr>
        <td id="L234" class="blob-num js-line-number" data-line-number="234"></td>
        <td id="LC234" class="blob-code blob-code-inner js-file-line">        socket:<span class="pl-c1">on</span>(<span class="pl-s"><span class="pl-pds">"</span>data<span class="pl-pds">"</span></span>, <span class="pl-k">function</span>(<span class="pl-smi">data</span>)</td>
      </tr>
      <tr>
        <td id="L235" class="blob-num js-line-number" data-line-number="235"></td>
        <td id="LC235" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">local</span> stringToParse</td>
      </tr>
      <tr>
        <td id="L236" class="blob-num js-line-number" data-line-number="236"></td>
        <td id="LC236" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">if</span> <span class="pl-k">#</span><span class="pl-v">self</span>.<span class="pl-smi">tempData</span> <span class="pl-k">&gt;</span> <span class="pl-c1">0</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L237" class="blob-num js-line-number" data-line-number="237"></td>
        <td id="LC237" class="blob-code blob-code-inner js-file-line">                stringToParse <span class="pl-k">=</span> <span class="pl-v">self</span>.<span class="pl-smi">tempData</span> <span class="pl-k">..</span> data</td>
      </tr>
      <tr>
        <td id="L238" class="blob-num js-line-number" data-line-number="238"></td>
        <td id="LC238" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L239" class="blob-num js-line-number" data-line-number="239"></td>
        <td id="LC239" class="blob-code blob-code-inner js-file-line">                stringToParse <span class="pl-k">=</span> data</td>
      </tr>
      <tr>
        <td id="L240" class="blob-num js-line-number" data-line-number="240"></td>
        <td id="LC240" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L241" class="blob-num js-line-number" data-line-number="241"></td>
        <td id="LC241" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">local</span> docLength <span class="pl-k">=</span>  <span class="pl-c1">read_msg_header</span>(stringToParse)</td>
      </tr>
      <tr>
        <td id="L242" class="blob-num js-line-number" data-line-number="242"></td>
        <td id="LC242" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">if</span> docLength <span class="pl-k">==</span> <span class="pl-k">#</span>stringToParse <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L243" class="blob-num js-line-number" data-line-number="243"></td>
        <td id="LC243" class="blob-code blob-code-inner js-file-line">                <span class="pl-k">local</span> requestId, cursorId , res, tags <span class="pl-k">=</span> <span class="pl-c1">parseData</span>(stringToParse)</td>
      </tr>
      <tr>
        <td id="L244" class="blob-num js-line-number" data-line-number="244"></td>
        <td id="LC244" class="blob-code blob-code-inner js-file-line">                <span class="pl-v">self</span>.<span class="pl-smi">tempData</span> <span class="pl-k">=</span> <span class="pl-s"><span class="pl-pds">"</span><span class="pl-pds">"</span></span></td>
      </tr>
      <tr>
        <td id="L245" class="blob-num js-line-number" data-line-number="245"></td>
        <td id="LC245" class="blob-code blob-code-inner js-file-line">                <span class="pl-v">self</span>.<span class="pl-smi">callbacks</span>[requestId].<span class="pl-c1">callback</span>(res, tags, cursorId)</td>
      </tr>
      <tr>
        <td id="L246" class="blob-num js-line-number" data-line-number="246"></td>
        <td id="LC246" class="blob-code blob-code-inner js-file-line">                <span class="pl-c1">table.remove</span>(<span class="pl-v">self</span>.<span class="pl-smi">queues</span>, <span class="pl-c1">1</span>)</td>
      </tr>
      <tr>
        <td id="L247" class="blob-num js-line-number" data-line-number="247"></td>
        <td id="LC247" class="blob-code blob-code-inner js-file-line">                <span class="pl-v">self</span>:<span class="pl-c1">sendRequest</span>()</td>
      </tr>
      <tr>
        <td id="L248" class="blob-num js-line-number" data-line-number="248"></td>
        <td id="LC248" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L249" class="blob-num js-line-number" data-line-number="249"></td>
        <td id="LC249" class="blob-code blob-code-inner js-file-line">                <span class="pl-v">self</span>.<span class="pl-smi">tempData</span> <span class="pl-k">=</span> stringToParse</td>
      </tr>
      <tr>
        <td id="L250" class="blob-num js-line-number" data-line-number="250"></td>
        <td id="LC250" class="blob-code blob-code-inner js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L251" class="blob-num js-line-number" data-line-number="251"></td>
        <td id="LC251" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">end</span>)</td>
      </tr>
      <tr>
        <td id="L252" class="blob-num js-line-number" data-line-number="252"></td>
        <td id="LC252" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L253" class="blob-num js-line-number" data-line-number="253"></td>
        <td id="LC253" class="blob-code blob-code-inner js-file-line">        socket:<span class="pl-c1">on</span>(<span class="pl-s"><span class="pl-pds">'</span>end<span class="pl-pds">'</span></span>, <span class="pl-k">function</span>()</td>
      </tr>
      <tr>
        <td id="L254" class="blob-num js-line-number" data-line-number="254"></td>
        <td id="LC254" class="blob-code blob-code-inner js-file-line">            socket:<span class="pl-c1">destroy</span>()</td>
      </tr>
      <tr>
        <td id="L255" class="blob-num js-line-number" data-line-number="255"></td>
        <td id="LC255" class="blob-code blob-code-inner js-file-line">            <span class="pl-v">self</span>:<span class="pl-c1">emit</span>(<span class="pl-s"><span class="pl-pds">"</span>end<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L256" class="blob-num js-line-number" data-line-number="256"></td>
        <td id="LC256" class="blob-code blob-code-inner js-file-line">            <span class="pl-v">self</span>:<span class="pl-c1">emit</span>(<span class="pl-s"><span class="pl-pds">"</span>close<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L257" class="blob-num js-line-number" data-line-number="257"></td>
        <td id="LC257" class="blob-code blob-code-inner js-file-line">            <span class="pl-c1">p</span>(<span class="pl-s"><span class="pl-pds">'</span>client end<span class="pl-pds">'</span></span>)</td>
      </tr>
      <tr>
        <td id="L258" class="blob-num js-line-number" data-line-number="258"></td>
        <td id="LC258" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">end</span>)</td>
      </tr>
      <tr>
        <td id="L259" class="blob-num js-line-number" data-line-number="259"></td>
        <td id="LC259" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L260" class="blob-num js-line-number" data-line-number="260"></td>
        <td id="LC260" class="blob-code blob-code-inner js-file-line">        socket:<span class="pl-c1">on</span>(<span class="pl-s"><span class="pl-pds">"</span>error<span class="pl-pds">"</span></span>, <span class="pl-k">function</span>(<span class="pl-smi">err</span>)</td>
      </tr>
      <tr>
        <td id="L261" class="blob-num js-line-number" data-line-number="261"></td>
        <td id="LC261" class="blob-code blob-code-inner js-file-line">            <span class="pl-c1">p</span>(<span class="pl-s"><span class="pl-pds">"</span>Error!<span class="pl-pds">"</span></span>, err)</td>
      </tr>
      <tr>
        <td id="L262" class="blob-num js-line-number" data-line-number="262"></td>
        <td id="LC262" class="blob-code blob-code-inner js-file-line">            <span class="pl-v">self</span>:<span class="pl-c1">emit</span>(<span class="pl-s"><span class="pl-pds">"</span>error<span class="pl-pds">"</span></span>, err)</td>
      </tr>
      <tr>
        <td id="L263" class="blob-num js-line-number" data-line-number="263"></td>
        <td id="LC263" class="blob-code blob-code-inner js-file-line">        <span class="pl-k">end</span>)</td>
      </tr>
      <tr>
        <td id="L264" class="blob-num js-line-number" data-line-number="264"></td>
        <td id="LC264" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L265" class="blob-num js-line-number" data-line-number="265"></td>
        <td id="LC265" class="blob-code blob-code-inner js-file-line">        <span class="pl-v">self</span>:<span class="pl-c1">emit</span>(<span class="pl-s"><span class="pl-pds">"</span>connect<span class="pl-pds">"</span></span>)</td>
      </tr>
      <tr>
        <td id="L266" class="blob-num js-line-number" data-line-number="266"></td>
        <td id="LC266" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">end</span>)</td>
      </tr>
      <tr>
        <td id="L267" class="blob-num js-line-number" data-line-number="267"></td>
        <td id="LC267" class="blob-code blob-code-inner js-file-line">    <span class="pl-v">self</span>.<span class="pl-smi">socket</span> <span class="pl-k">=</span> socket</td>
      </tr>
      <tr>
        <td id="L268" class="blob-num js-line-number" data-line-number="268"></td>
        <td id="LC268" class="blob-code blob-code-inner js-file-line"><span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L269" class="blob-num js-line-number" data-line-number="269"></td>
        <td id="LC269" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L270" class="blob-num js-line-number" data-line-number="270"></td>
        <td id="LC270" class="blob-code blob-code-inner js-file-line">Mongo.<span class="pl-smi">ObjectId</span> <span class="pl-k">=</span> ObjectId</td>
      </tr>
      <tr>
        <td id="L271" class="blob-num js-line-number" data-line-number="271"></td>
        <td id="LC271" class="blob-code blob-code-inner js-file-line">Mongo.<span class="pl-smi">Bit32</span> <span class="pl-k">=</span> bson.<span class="pl-smi">Bit32</span></td>
      </tr>
      <tr>
        <td id="L272" class="blob-num js-line-number" data-line-number="272"></td>
        <td id="LC272" class="blob-code blob-code-inner js-file-line">Mongo.<span class="pl-smi">Bit64</span> <span class="pl-k">=</span> bson.<span class="pl-smi">Bit64</span></td>
      </tr>
      <tr>
        <td id="L273" class="blob-num js-line-number" data-line-number="273"></td>
        <td id="LC273" class="blob-code blob-code-inner js-file-line">Mongo.<span class="pl-smi">Date</span> <span class="pl-k">=</span> bson.<span class="pl-smi">Date</span></td>
      </tr>
      <tr>
        <td id="L274" class="blob-num js-line-number" data-line-number="274"></td>
        <td id="LC274" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L275" class="blob-num js-line-number" data-line-number="275"></td>
        <td id="LC275" class="blob-code blob-code-inner js-file-line">module <span class="pl-k">=</span> module <span class="pl-k">or</span> {}</td>
      </tr>
      <tr>
        <td id="L276" class="blob-num js-line-number" data-line-number="276"></td>
        <td id="LC276" class="blob-code blob-code-inner js-file-line">module.<span class="pl-smi">exports</span> <span class="pl-k">=</span> Mongo</td>
      </tr>
      <tr>
        <td id="L277" class="blob-num js-line-number" data-line-number="277"></td>
        <td id="LC277" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
</tbody></table>
  </div>
    --]]}, nil, function(result)
        m:find("abc", {_id = result[1]._id}, nil, nil, nil, function(res)
            assert(res[1].content == result[1].content, ":( not match")
            p("Wow , PASS")
        end)
    end )

    m:insert("abc", {
        _id = ObjectId.new(),
        long = Bit64(123.2),
        int = Bit32(23840.3),
        time = Date(os.time()),
        longTime = Bit64(os.time() * 1000),
        float = 123.4
    }, nil, function(result)
        p("Result:", result)
    end)

end)

