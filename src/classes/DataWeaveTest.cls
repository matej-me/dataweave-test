/**
 * Created by matej on 12-02-2023.
 */

public with sharing class DataWeaveTest
{
	public static String getContactsCSV()
	{
		HttpRequest req = new HttpRequest();

		req.setEndpoint('https://gist.githubusercontent.com/matej-me/9222b396c7bea8339325632eabfecd72/raw/b68f39021fbb48e75859118f3d8948811432c756/gistfile1.txt');
		req.setMethod('GET');
		req.setTimeout(120000);
		HttpResponse resp = new Http().send(req);
		String responseBody = resp.getBody();
		return responseBody;
	}

	public static void transformWithDataweave()
	{
		String responseBody = getContactsCSV();
		DataWeave.Script dwscript = new DataWeaveScriptResource.ParseContactsCSV();
		DataWeave.Result dwresult = dwscript.execute(new Map<String, Object> {'records' => responseBody});
		List<Contact> contactsRetrieved = (List<Contact>) dwresult.getValue();
		System.debug('contactsRetrieved.size(): ' + contactsRetrieved.size());

		System.debug('CPUTime: ' + Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime());
		System.debug('HeapSize: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());

		System.debug('contacts: ' + contactsRetrieved);

	}

	public static void transformManually()
	{
		String responseBody = getContactsCSV();

		List<Contact> contacts = new List<Contact>();

		for(String contact : responseBody.split('\n'))
		{
			if(contact.contains('FirstName')) continue;
			List<String> contactAttributes = contact.split(',');
			contacts.add(new Contact(FirstName = contactAttributes[0], LastName = contactAttributes[1], Email = contactAttributes[2] ));
		}

		System.debug('contacts.size(): ' + contacts.size());

		System.debug('CPUTime: ' + Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime());
		System.debug('HeapSize: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());

		System.debug('contacts: ' + contacts);
	}
}