import Array "mo:base/Array";   //thaw, freeze
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

func sort(s : [var Int], start : Nat, end : Nat) : (){    //初次为0, length - 1
    var i = start;
    var j = end;
        
    s[0] := s[start];
    while(i < j){
        while(i < j and s[0] < s[j]){
            j := j - 1;
        };
        if(i < j){
            s[i] := s[j];
            i := i + 1;
        };
        while(i < j and s[i] <= s[0]){
            i := i + 1;
        };
        if(i < j){
            s[j] := s[i];
            j := j - 1;
        };
    };
    s[i] := s[0];
    if(start < i){
        sort(s, start, j - 1);
    };
    if(i < end){
        sort(s, j + 1, end);
    };
};

func quicksort(arr : [var Int]) : (){
    if(Iter.size<Int>(Array.vals<Int>(Array.freeze<Int>(arr))) == 0){
        return;
    };
    var re0_arr = Array.make<Int>(arr[0]);
    re0_arr := Array.append<Int>(re0_arr, Array.freeze<Int>(arr));
    var tmp_arr : [var Int] = Array.thaw<Int>(re0_arr);
    sort(tmp_arr, 1, Iter.size<Int>(Array.vals<Int>(Array.freeze<Int>(arr))));
    for(i in Iter.range(1, Iter.size<Int>(Array.vals<Int>(Array.freeze<Int>(arr))))){
        arr[i-1] := tmp_arr[i];
    };
};

/* 测试：
var test_arr : [var Int]= [var 8, 2, 5, 4, 9, 1, 6];
quicksort(test_arr);
Debug.print(debug_show(test_arr));
*/