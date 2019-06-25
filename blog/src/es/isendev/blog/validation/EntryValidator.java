// (c) 2019 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.validation;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import es.isendev.blog.dao.beans.Entry;

@Component("EntryValidator")
public class EntryValidator implements Validator {
	
	@Override
	@SuppressWarnings("rawtypes")
	public boolean supports(Class classToValidate) {
		return Entry.class.equals(classToValidate);
	}

	@Override
	public void validate(Object obj, Errors errs) {
		
		// ValidationUtils methods default to default message if message code is not specified.		
        ValidationUtils.rejectIfEmptyOrWhitespace(errs, "title", "field.required");
        ValidationUtils.rejectIfEmpty(errs, "description", "field.required");
        ValidationUtils.rejectIfEmpty(errs, "body", "field.required");

	}

}
