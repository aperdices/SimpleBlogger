// (c) 2016 Antonio Perdices.
// License: Public Domain.
// You can use this code freely and wisely in your applications.

package es.isendev.blog.util;

import java.io.Serializable;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Set;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ProcessBBCode implements Serializable {

	private static final long serialVersionUID = 1L;

	private static final String CR_LF = "(?:\r\n|\r|\n)?";

    private boolean acceptHTML = false;

    private boolean acceptBBCode = true;

    public boolean getAcceptBBCode() {
        return acceptBBCode;
    }

    public void setAcceptBBCode(boolean acceptBBCode) {
        this.acceptBBCode = acceptBBCode;
    }

    public boolean getAcceptHTML() {
        return acceptHTML;
    }

    public void setAcceptHTML(boolean acceptHTML) {
        this.acceptHTML = acceptHTML;
    }

    // Default processing function.
    // This is the function that must be called to process BBCode strings   
    public String prepareEntryText(String text) {
        
    	// If accepting HTML code, escape first.
    	if (!getAcceptHTML()) {
            text = escapeHtml(text);
        }
    	
    	// Process BBCode string.
        if (getAcceptBBCode()) {
            text = process(text);
        }
        return text;
    }

    // Process BBCode string
    // Returns HTML-formatted string.
    private String process(String string) {
    	
    	// Replace all types of carriage returns with paragraphs.
    	String[] paragraphs = string.split("(\r\n|\n\r|\n|\r)");
    	string = "";
    	for (String p : paragraphs) {
    		if (p != null && p != "") {
    			p = p.trim();
    			if (p.length() > 0) {
    				string += "<p>" + p + "</p>";
    			}
    		}
		}

        // Process [code]<text>[/code] tags.
    	StringBuffer buffer = new StringBuffer(string);
        processCode(buffer);

        // Process [quote]<text>[quote] and [quote="<quotetitle>"]<text>[quote] tags.
        processNestedTags(buffer,
            "quote",
            "<blockquote><p><em>{BBCODE_PARAM}</em></p><p>",
            "</p></blockquote>",
            "<blockquote>",
            "</blockquote>",
            "[*]",
            false,
            true,
            true);

        processNestedTags(buffer,
            "list",
            "<ol class=\"list\" type=\"{BBCODE_PARAM}\">",
            "</ol>",
            "<ul class=\"list\">",
            "</ul>",
            "<li>",
            true,
            true,
            true);
        
        // Next transformations can be done with a String.
        String str = buffer.toString();

        // [color="<colorname>"]<text>[/color] Tag processing.
        str = str.replaceAll("\\[color=['\"]?(.*?[^'\"])['\"]?\\](.*?)\\[/color\\]", "<span style='color:$1'>$2</span>");

        // [size="<sizeinpx>"]<text>[/size] Tag processing.
        str = str.replaceAll("\\[size=['\"]?([0-9]|[1-2][0-9])['\"]?\\](.*?)\\[/size\\]", "<span style='font-size:$1px'>$2</span>");

        // [b]<text>[/b] Tag processing.
        str = str.replaceAll("\\[b\\](.*?)\\[/b\\]", "<strong>$1</strong>");
        
        // [u]<text>[/u] Tag processing.
        str = str.replaceAll("\\[u\\](.*?)\\[/u\\]", "<u>$1</u>");
        
        // [i]<text>[/i] Tag processing.        
        str = str.replaceAll("\\[i\\](.*?)\\[/i\\]", "<em>$1</em>");

        // [url]<linkurl>[/url] Tag processing (same href and link text).
        str = str.replaceAll("\\[url\\](.*?)\\[/url\\]", "<a href='$1' target='_blank'>$1</a>");
        
        // [url="<linkurl>"]<linktext>[/url] Tag processing (different href and link text).
        str = str.replaceAll("\\[url=['\"]?(.*?[^'\"])['\"]?\\](.*?)\\[/url\\]", "<a href=\"$1\" target=\"_new\">$2</a>");

        // [img]<imgurl>[/img] Tag processing.
        str = str.replaceAll("\\[img\\](.*?)\\[/img\\]", "<div class=\"vertical-spacing-wrapper\"><img class=\"img-responsive center-block\" src=\"$1\"/></div>");
        
        // [img="<imgurl>"]<imgtitle>[/img] Tag processing (with caption).
        str = str.replaceAll("\\[img=['\"]?(.*?[^'\"])['\"]?\\](.*?)\\[/img\\]", "<div class=\"vertical-spacing-wrapper\"><img class=\"img-responsive center-block\" src=\"$1\" title=\"$2\" /></div>");

        // [youtube]<text>[/youtube] Tag processing.
        str = str.replaceAll("\\[youtube\\](.*?)\\[/youtube\\]", "<div class=\"vertical-spacing-wrapper\"><div class=\"embed-responsive embed-responsive-4by3\"><iframe class=\"embed-responsive-item\" src=\"http://www.youtube.com/embed/$1\"></iframe></div></div>");
        
        return str;
    }

    // [code] Tag processing function.
    private static void processCode(StringBuffer buffer) {
    	
        int start = buffer.indexOf("[code]");
        int end;

        for (; (start >= 0) && (start < buffer.length()); start = buffer.indexOf("[code]", end)) {

            end = buffer.indexOf("[/code]", start);

            if (end < 0) {
                break;
            }

            end += "[/code]".length();
            
            // Get content between [code][/code] tags
            // and escape BBCode on it.
            String content = buffer.substring(start + "[code]".length(), end - "[/code]".length());
            content = escapeBBcode(content);

            // Get all HTML carriage return occurrence
            // and replace them with simple carriage return character.
            content = content.replaceAll("<br>", "\n");
            
            // Put content inside a styled preformatted HTML tag <pre>
            String replacement = "<div class=\"vertical-spacing-wrapper\"><pre class=\"pre-scrollable\">" + content + "</pre></div>";            
            
            buffer.replace(start, end, replacement);

            end = start + replacement.length();
        }
    }

    // BBCode escaping function.
    public static String escapeBBcode(String content) {
        
    	// Escaping single characters.
        content = replaceAll(content, "[]\t".toCharArray(), new String[] {"&#91;","&#93;","&nbsp; &nbsp;" });

        // Taking off start and end line breaks.
        content = content.replaceAll("\\A\r\n|\\A\r|\\A\n|\r\n\\z|\r\\z|\n\\z", "");

        // Replacing spaces for &nbsp; to keep indentation;
        content = content.replaceAll("  ", "&nbsp; ");
        content = content.replaceAll("  ", " &nbsp;");

        return content;
    }
    
    // HTML escaping function.
    private static String escapeHtml(String content) {
        
    	// Escaping single characters.
        content = replaceAll(content, "&<>".toCharArray(), new String[] { "&amp;", "&lt;", "&gt;" });

        return content;
    }

    // Custom replaceAll function.
    // Replace every char ocurrences for each ocurrences array element in text string
    // with correspondent string in replacements array  
    private static String replaceAll(String text, char[] ocurrences, String[] replacements) {

        StringBuffer buffer = new StringBuffer();
        
        for (int i = 0; i < text.length(); i++) {

        	char c = text.charAt(i);
        	boolean matched = false;
        	
        	for (int j = 0; j < ocurrences.length; j++) {
        		if (c == ocurrences[j]) {
        			buffer.append(replacements[j]);
        			matched = true;
        		}
        	}
        	
        	if (!matched) {
        		buffer.append(c);
        	}
        }

        return buffer.toString();
    }

    // @param buffer
    // @param tagName
    // @param openSubstWithParam
    // @param closeSubstWithParam
    // @param openSubstWithoutParam
    // @param closeSubstWithoutParam
    // @param internalSubst
    // @param processInternalTags
    // @param acceptParam
    // @param requiresQuotedParam

    @SuppressWarnings({ "unchecked", "rawtypes" })
	private static void processNestedTags(

		StringBuffer buffer,
        String tagName,
        String openSubstWithParam,
        String closeSubstWithParam,
        String openSubstWithoutParam,
        String closeSubstWithoutParam,
        String internalSubst,
        boolean processInternalTags,
        boolean acceptParam,
        boolean requiresQuotedParam) {
        String str = buffer.toString();

        Stack openStack = new Stack();
        Set subsOpen = new HashSet();
        Set subsClose = new HashSet();
        Set subsInternal = new HashSet();

        String openTag = CR_LF + "\\["
            + tagName
            + (acceptParam ? (requiresQuotedParam ? "(?:=\'(.*?)\')?" : "(?:=\'?(.*?)\'?)?") : "")
            + "\\]"
            + CR_LF;
        String closeTag = CR_LF + "\\[/" + tagName + "\\]" + CR_LF;
        String internTag = CR_LF + "\\[\\*\\]" + CR_LF;

        String patternString = "(" + openTag + ")|(" + closeTag + ")";

        if (processInternalTags) {
            patternString += "|(" + internTag + ")";
        }

        Pattern tagsPattern = Pattern.compile(patternString);
        Matcher matcher = tagsPattern.matcher(str);

        int openTagGroup;
        int paramGroup;
        int closeTagGroup;
        int internalTagGroup;

        if (acceptParam) {
            openTagGroup = 1;
            paramGroup = 2;
            closeTagGroup = 3;
            internalTagGroup = 4;
        } else {
            openTagGroup = 1;
            paramGroup = -1; // INFO
            closeTagGroup = 2;
            internalTagGroup = 3;
        }

        while (matcher.find()) {
            int length = matcher.end() - matcher.start();
            MutableCharSequence matchedSeq = new MutableCharSequence(str, matcher.start(), length);

            // test opening tags
            if (matcher.group(openTagGroup) != null) {
                if (acceptParam && (matcher.group(paramGroup) != null)) {
                    matchedSeq.param = matcher.group(paramGroup);
                }

                openStack.push(matchedSeq);

                // test closing tags
            } else if ((matcher.group(closeTagGroup) != null) && !openStack.isEmpty()) {
                MutableCharSequence openSeq = (MutableCharSequence) openStack.pop();

                if (acceptParam) {
                    matchedSeq.param = openSeq.param;
                }

                subsOpen.add(openSeq);
                subsClose.add(matchedSeq);

                // test internal tags
            } else if (processInternalTags && (matcher.group(internalTagGroup) != null)
                && (!openStack.isEmpty())) {
                subsInternal.add(matchedSeq);
            } else {
                // assert (false);
            }
        }

        LinkedList subst = new LinkedList();
        subst.addAll(subsOpen);
        subst.addAll(subsClose);
        subst.addAll(subsInternal);

        Collections.sort(subst, new Comparator() {
            public int compare(Object o1, Object o2) {
                MutableCharSequence s1 = (MutableCharSequence) o1;
                MutableCharSequence s2 = (MutableCharSequence) o2;
                return -(s1.start - s2.start);
            }
        });

        buffer.delete(0, buffer.length());

        int start = 0;

        while (!subst.isEmpty()) {
            MutableCharSequence seq = (MutableCharSequence) subst.removeLast();
            buffer.append(str.substring(start, seq.start));

            if (subsClose.contains(seq)) {
                if (seq.param != null) {
                    buffer.append(closeSubstWithParam);
                } else {
                    buffer.append(closeSubstWithoutParam);
                }
            } else if (subsInternal.contains(seq)) {
                buffer.append(internalSubst);
            } else if (subsOpen.contains(seq)) {
                Matcher m = Pattern.compile(openTag).matcher(str.substring(seq.start, seq.start + seq.length));

                if (m.matches()) {
                    if (acceptParam && (seq.param != null)) {
                        buffer.append(openSubstWithParam.replaceAll("\\{BBCODE_PARAM\\}", seq.param));
                    } else {
                        buffer.append(openSubstWithoutParam);
                    }
                }
            }

            start = seq.start + seq.length;
        }

        buffer.append(str.substring(start));
    }

    static class MutableCharSequence implements CharSequence {
        /** */
        public CharSequence base;

        /** */
        public int start;

        /** */
        public int length;

        /** */
        public String param = null;

        /**
         */
        public MutableCharSequence() {
            //
        }

        /**
         * @param base
         * @param start
         * @param length
         */
        public MutableCharSequence(CharSequence base, int start, int length) {
            reset(base, start, length);
        }

        /**
         * @see java.lang.CharSequence#length()
         */
        public int length() {
            return this.length;
        }

        /**
         * @see java.lang.CharSequence#charAt(int)
         */
        public char charAt(int index) {
            return this.base.charAt(this.start + index);
        }

        /**
         * @see java.lang.CharSequence#subSequence(int, int)
         */
        public CharSequence subSequence(int pStart, int end) {
            return new MutableCharSequence(this.base,
                this.start + pStart,
                this.start + (end - pStart));
        }

        /**
         * @param pBase
         * @param pStart
         * @param pLength
         * @return -
         */
        public CharSequence reset(CharSequence pBase, int pStart, int pLength) {
            this.base = pBase;
            this.start = pStart;
            this.length = pLength;

            return this;
        }

        /**
         * @see java.lang.Object#toString()
         */
        public String toString() {
            StringBuffer sb = new StringBuffer();

            for (int i = this.start; i < (this.start + this.length); i++) {
                sb.append(this.base.charAt(i));
            }

            return sb.toString();
        }

    }
    
}
