// Example of how to pull a payload from a method and cast it into a particular datatype.


Map<String, List<String>> payload = null;

Object getPayload () {

    return (Object)new Map<String, List<String>> { 'Fruit'      => new List<string> { 'Banna', 'Strawberry', 'Blueberries' },
                                                   'Vegetables' => new List<string> { 'Squash', 'Yams', 'Potatoes' },
                                                   'Tea'        => new List<string> { 'Chai Black Tea', 'Green Tea', 'Sassafrass Tea' }};
}

payload = (Map<String, List<String>>)getPayload ();

System.debug ('DEBUG.Anon.01.1 payload: ['+payload+']');
