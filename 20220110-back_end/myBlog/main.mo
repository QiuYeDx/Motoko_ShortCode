import List "mo:base/List";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Time "mo:base/Time";

actor {
    private type Time = Time.Time;
    private type Message = {
        text: Text;
        time: Time;
    };
    private type MyBlog = actor{
        follow: shared (Principal) -> async ();
        follows: shared query() -> async [Principal];
        post: shared (Time) -> async ();
        posts: shared query (Time) -> async [Message];
        timeline: shared (Time) -> async [Message];
    };

    stable var followed : List.List<Principal> = List.nil();
    stable var messages : List.List<Message> = List.nil();

    public shared func follow(id: Principal) : async (){
        followed := List.push(id, followed);
    };
    
    public shared query func follows() : async [Principal]{
        List.toArray(followed)
    };

    public shared ({caller}) func post(text: Text) : async (){
        //Security Check
        //assert(Principal.toText(caller) == "..."); 
        var msg : Message = {
            text = text;
            time = Time.now();
        };
        messages := List.push(msg, messages);
    };

    public shared query func posts(since: Time) : async [Message]{
        var all : List.List<Message> = List.nil();
        for(msg in Iter.fromArray(List.toArray(messages))){
            if(msg.time >= since){
                all := List.push(msg, messages);
            };
        };
        List.toArray(all)
    };

    public shared func timeline(since: Time) : async [Message]{
        var all : List.List<Message> = List.nil();
        for(id in Iter.fromList(followed)){
            let canister : MyBlog = actor(Principal.toText(id));
            let msgs = await canister.posts(0);
            for(msg in Iter.fromArray(msgs)){
                if(msg.time >= since){
                    all := List.push(msg, all);
                };
            };
        };
        List.toArray(all)
    };

};
