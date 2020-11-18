Predict_ngram_fast <- function(input_text, complete_dt, verbose=TRUE){
        # If verbose is TRUE, output confidence

        # Apply cleaning function to input text. And reverses the texts order
        cleaned_text <- split_and_clean(input_text)
        cleaned_text <- unlist(strsplit(cleaned_text, split=" "), use.names = FALSE)
        
        matched_row <- data.frame()
        n=4
        while (nrow(matched_row)==0 && n>=1){
                
                preceding_text <- paste(tail(cleaned_text, n), collapse=" ") 
                matched_row <- complete_dt[Preceding==preceding_text]
                
                n <- n-1
        }
        if(nrow(matched_row)==0){
                matched_row <- complete_dt[Preceding=="<Null>"]
        }
        
        # Extract row info here
        output <- data.frame("Top_Choices" = c(matched_row$top1, 
                                               matched_row$top2, 
                                               matched_row$top3, 
                                               matched_row$top4, 
                                               matched_row$top5), 
                             "Scores" = as.numeric(c(matched_row$score1, 
                                                     matched_row$score2, 
                                                     matched_row$score3, 
                                                     matched_row$score4, 
                                                     matched_row$score5)))
        if(verbose){
                total <- output %>% mutate(sum_val = ifelse(Scores > 1.0, Scores, 1.0)) %>% select(sum_val) %>% sum()
                output <- output %>% mutate(Confidence_Score = paste0(as.character(round(100*Scores/total, 2)), "%")) %>% select(Top_Choices, Confidence_Score)
        }
        return(output)
}

unicode_fix <- function(txt){
        output_txt <- gsub('[”“\u2033]', '"', txt, perl=TRUE)
        output_txt <- gsub('[\u2018\u2019\u2032\u00B4\u0092]', "'", output_txt, perl=TRUE)
        output_txt <- gsub('[—–]', "-", output_txt, perl=TRUE)
        output_txt <- gsub('…', "...", output_txt, perl=TRUE)
        output_txt <- gsub('：', ":", output_txt, perl=TRUE)
        
        output_txt <- gsub('[\u01CE\u00E0äàáã\u00E2\u0101\u0430]', "a", output_txt, perl=TRUE)
        output_txt <- gsub('[ç\u010D]', "c", output_txt, perl=TRUE)
        output_txt <- gsub('[êéè]', "e", output_txt, perl=TRUE)
        output_txt <- gsub('[í\u00ED\u012B\u1ECB]', "i", output_txt, perl=TRUE)
        output_txt <- gsub('[ñ\u1E47]', "n", output_txt, perl=TRUE)
        output_txt <- gsub('[ốôờøó\u01A1\u00F6\u1EDB\u1ED9\u00F0]', "o", output_txt, perl=TRUE)
        output_txt <- gsub('[\u1E5B]', "r", output_txt, perl=TRUE)
        output_txt <- gsub('[\u015A\u1E63\u015B]', "s", output_txt, perl=TRUE)
        output_txt <- gsub('[üú\u01B0\u016B]', "u", output_txt, perl=TRUE)
        
        output_txt <- gsub('¼', "a quarter", output_txt, perl=TRUE)
        output_txt <- gsub('½', "a half", output_txt, perl=TRUE)
        output_txt <- gsub('⅛', "an eighth", output_txt, perl=TRUE)
        output_txt <- gsub('⅔', "two thirds", output_txt, perl=TRUE)
        
        return(output_txt)
}

text_fix <- function(txt){
        cleaned_text <- gsub("^RT[^a-zA-Z]", "retweet ", txt, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))[sS]/[Oo](?=( |$))", " shoutout ", cleaned_text, perl=TRUE)      
        
        cleaned_text <- textclean::replace_contraction(cleaned_text) %>% char_tolower()
        cleaned_text <- textclean::replace_word_elongation(cleaned_text)
        cleaned_text <- gsub("where'd", " where did ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("haven't", " have not ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("hadn't", " had not ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("there'd", " there would ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("y'all", " you all ", cleaned_text, perl=TRUE)
        
        cleaned_text <- replace_ordinal(cleaned_text)
        cleaned_text <- gsub("((?<=^)|(?<= ))0(?=( |$))", " zero ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))1(?=( |$))", " one ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))2(?=( |$))", " two ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))3(?=( |$))", " three ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))4(?=( |$))", " four ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))5(?=( |$))", " five ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))6(?=( |$))", " six ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))7(?=( |$))", " seven ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))8(?=( |$))", " eight ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))9(?=( |$))", " nine ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))10(?=( |$))", " ten ", cleaned_text, perl=TRUE)
        ## Fix possessive. Must come after the contraction fix
        cleaned_text <- gsub("([a-z])'s([^a-z])", "\\1\\2", cleaned_text, perl=TRUE)
        
        # Specific Common fixes
        cleaned_text <- gsub("((?<=^)|(?<= ))fwd(?=( |$))", " forward ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))t-shirt", " tshirt", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))a.m.(?=( |$))", " am ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))p.m.(?=( |$))", " pm ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))ff(?=( |$))", " forfeit ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))tho(?=( |$))", " though ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))dm(?=( |$))", " direct message ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))b/c(?=( |$))", " because ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))im(?=( |$))", " i am ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))rt(?=( |$))", " right ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))u(?=( |$))", " you ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))r(?=( |$))", " are ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))w(?=( |$))", " with ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))k(?=( |$))", " okay ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))yea(?=( |$))", " yeah ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))dont(?=( |$))", " do not ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))cant(?=( |$))", " can not ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))u.s.(a.?)?(?=( |$))", " united states ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))the u.?s.?(a.?)?(?=( |$))", " the united states ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))wanna(?=( |$))", " want to ", cleaned_text, perl=TRUE)
        cleaned_text <- gsub("((?<=^)|(?<= ))gonna(?=( |$))", " going to ", cleaned_text, perl=TRUE)
        
        return(cleaned_text)
}

text_delete <- function(txt){
        # Remove URLS
        output_text <- gsub("((?<=^)|(?<= ))\\S*(www|\\.com)\\S*(?=( |$))", " <del> ", txt, perl=TRUE)
        # Remove sentence ending punctuation
        output_text <- gsub("[[:punct:]]+\\s*$", " ", output_text, perl=TRUE)
        # Remove punctuation and digits
        output_text <- gsub("(\\S*)[[:punct:]]+(?= )", "\\1", output_text, perl=TRUE)
        output_text <- gsub("((?<=^)|(?<= ))\\S*([[:punct:]]+|[0-9]+)\\S*(?=( |$))", " <del> ", output_text, perl=TRUE)
        # Delete remaining ASCII characters
        output_text <- gsub('((?<=^)|(?<= ))\\S*[^\x20-\x7E]+\\S*(?=( |$))', ' <del> ', output_text, perl=TRUE)
        # Delete certain individual letters or cases of 're'
        output_text <- gsub('((?<=^)|(?<= ))(re|[bcdefghjklmnopqrstvwxyz])(?=( |$))', ' <del> ', output_text, perl=TRUE)
        
        output_text <- gsub('<del>( +<del>)+', '<del>', output_text, perl=TRUE)
        
        return(output_text)
}

add_start <- function(lines){
        paste0("<start> ", lines)
}

remove_profanity <- function(txt){
        # Remove words in the profanity list
        profanity_words <- readtext("./data/swear_list.txt")
        profanity_words <- unlist(strsplit(profanity_words$text, split="\n")) %>% paste0(collapse='|')
        output_text <- gsub(paste0('((?<=^)|(?<= ))(', profanity_words, ')()(?=( |$))'), ' <del> ', txt, perl=TRUE)
        
        return(output_text)
}

split_and_clean <- function(text){
        
        output_text <- text %>% 
                corpus() %>%
                corpus_reshape(to = "sentences") %>%
                tolower() %>% 
                unicode_fix() %>%
                text_fix() %>%
                text_delete() %>%
                add_start() %>%
                remove_profanity()
        
        return(output_text)
}
