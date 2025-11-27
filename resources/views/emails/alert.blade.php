<h2>{{ $data['subject'] }}</h2>
<p>{{ $data['message'] }}</p>

@if(isset($data['extra']))
<pre>{{ json_encode($data['extra'], JSON_PRETTY_PRINT) }}</pre>
@endif
<p>Regards,<br/>Your Alert System</p>