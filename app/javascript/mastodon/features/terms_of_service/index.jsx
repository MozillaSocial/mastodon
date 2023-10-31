/* eslint-disable react/no-unescaped-entities */
import PropTypes from 'prop-types';
import React from 'react';

import { injectIntl } from 'react-intl';

import { Helmet } from 'react-helmet';


import Column from 'mastodon/components/column';

class TermsOfService extends React.PureComponent {

  static propTypes = {
    intl: PropTypes.object,
    multiColumn: PropTypes.bool,
  };

  state = {
    content: null,
    lastUpdated: null,
    isLoading: true,
  };

  render() {
    const { multiColumn } = this.props;

    return (
      <Column bindToDocument={!multiColumn} label='Terms of service'>
        <div className='scrollable privacy-policy'>
          <div className='column-title'>
            <h3>Terms of Service</h3>
            <p>Version 0.2, effective November 1, 2023</p>
          </div>

          <div className='privacy-policy__body prose'>
            <p>Mozilla.social is an instance of <a href='https://mastodon.social/explore'>Mastodon</a>, a website where
              you can share quick, short messages, publicly or with specific
              people. We provide Mozilla.social as a free service.</p>

            <p>Please read these Terms of Service carefully because they
              explain important information about your use of Mozilla.social.
              By using Mozilla.social you agree to be bound by these Terms, the
              Privacy Notice, and the Content Policies. If you agree to these
              Terms on behalf of an entity, such as your employer, you
              represent that you are authorized to and intend to bind that
              entity.</p>

            <h2 id='mozilla-account'>You'll Need A Mozilla Account</h2>

            <p>You need a Mozilla account to use Mozilla.social. To create a Mozilla account, you will also need to agree
              to the <a href='https://www.mozilla.org/about/legal/terms/services/'>Terms of Service</a>
              and <a href='https://www.mozilla.org/privacy/firefox/'>Privacy Notice</a> for your Mozilla account.</p>

            <h2 id='your-privacy'>Your Privacy</h2>

            <p>The <a href='https://mozilla.social/privacy-policy'>Mozilla.social Privacy
              Notice</a> explains what information you provide to Mozilla when
              you use the Services, and how we handle that information.</p>

            <p>Mozilla is a global organization, and Mozilla.social is a
              "federated" service. This means our computers, our service
              providers' computers, and computers hosting other Mastodon
              instances may be in various countries around the world, including
              the United States. Your information might be processed on servers
              located outside of the country where you live, and that country
              may have a different level of data protection regulation than
              yours. By giving us information, you consent to this kind of
              transfer of your information.</p>

            <h2 id='you-must-be-eligible'>You Must Be Eligible</h2>

            <p>You must be 18 or older to sign up for and use
              Mozilla.social.</p>

            <h2 id='permissions'>Permissions for Mozilla.Social</h2>

            <p>Your Use of the Service.&nbsp;Mozilla gives you permission to
              use Mozilla.social according to these Terms of Service. This
              permission is only for your personal use. You may not transfer,
              sublicense, or resell the service.</p>

            <p>Your Feedback and Suggestions. If you give Mozilla any ideas,
              suggestions, or feedback, you give Mozilla permission to use it
              for free and without any obligation to you.</p>

            <p>Mozilla's Intellectual Property. Neither Mozilla nor its
              licensors grant you any intellectual property rights in
              Mozilla.social or other Mozilla services that are not
              specifically stated in these Terms. For example, these Terms do
              not provide the right to use any copyrights, trademarks, or other
              distinctive brand features of Mozilla or its licensors.</p>

            <p>Your Intellectual Property. You retain your rights to any
              content you post or submit through Mozilla.social. By submitting
              or posting content to Mozilla.social, you grant us a worldwide,
              non-exclusive, sublicensable, and royalty-free license to use,
              copy, modify, publish, and display it on Mozilla.social. This
              license authorizes us to make your content available publicly and
              to let others do the same.</p>

            <p>To learn more about how Mozilla.social works and the data we
              process, you can see Mozilla's <a href='https://github.com/mozilla/mastodon'>source code</a>,
              the <a href='https://github.com/mastodon/mastodon'>source code for Mastodon</a>,&nbsp;
              and the <a href='https://mozilla.social/privacy-policy'>Mozilla.social Privacy Notice</a></p>

            <h2 id='cancel'>You May Cancel Your Account at Any Time</h2>

            <p>You may cancel your Mozilla.social account at any time. You
              can do this by navigating to the <a href='https://mozilla.social/settings/delete'>Account settings</a>,
              entering your username, and clicking "Delete Account." If you
              choose to cancel, we may delete your Mozilla.social account and
              any of your personal information associated with your
              Mozilla.social account. However, we may retain such data to the
              extent necessary in order to enforce our policies or comply with
              the law, as described in the Mozilla.social Privacy Notice. This
              will not delete your Mozilla account, which you may delete
              separately on your Mozilla account <a href='https://accounts.firefox.com/'>settings page</a>.</p>

            <h2 id='you-are-responsible'>You Are Responsible For the Content You Provide</h2>

            <ul>
              <li>You should only post content you are comfortable sharing
                with others. You can learn more about who can access the
                content that you share in the <a href='https://mozilla.social/privacy-policy'>Mozilla.social Privacy
                  Notice</a></li>

              <li>You assure Mozilla that you will not use Mozilla.social to
                infringe anyone's rights or violate any law, and that you have
                all rights and permissions necessary to grant us the rights in
                these Terms.</li>

              <li>Content posted on Mozilla.social reflects the views of the
                person who posted it, not those of Mozilla. People may
                post&#8211;and you may see&#8211;content you disagree with or
                that offends you. You agree that you will comply with the
                Mozilla.social Content Policies. We reserve the right to remove
                or limit the visibility of such content, and to suspend any
                users we reasonably believe have violated the Mozilla.social
                Content Policies, however, we cannot take responsibility for
                all content posted on Mozilla.social.</li>
            </ul>

            <h2 id='you-are-responsible-consequences'>You Are Responsible For the Consequences of Your Use of the
              Service</h2>

            <ul>
              <li>To the extent permitted by applicable law, you agree that
                Mozilla will not be liable in any way for any inability to use
                Mozilla.social or for any limitations of the service. Mozilla
                specifically disclaims the following: Indirect, special,
                incidental, consequential, or exemplary damages, direct or
                indirect damages for loss of goodwill, work stoppage, lost
                profits, loss of data, or computer malfunction. Any liability
                for Mozilla under this agreement is limited to $500.</li>

              <li>You agree to indemnify and hold Mozilla harmless for any
                liability or claim that results from your activities on
                Mozilla.social, to the extent permitted by applicable law.</li>

              <li>Mozilla provides Mozilla.social "as is." To the extent
                permitted by applicable law, Mozilla specifically disclaims any
                legal guarantees or warranties such as "merchantability,"
                "fitness for a particular purpose," "non-infringement," and
                warranties arising out of a course of dealing, usage, or
                trade</li>
            </ul>

            <h2 id='we-can-update'>We Can Update These Terms</h2>

            <p>Mozilla Can Update These Terms. Every once in a while, Mozilla
              may decide to update these Terms. We will post the updated Terms
              online. We will take your continued use of the Services as
              acceptance of such changes. We will post an effective date at the
              top of this page to make it clear when we made our most recent
              update. If the update is significant, we will contact you at the
              primary email address for your Mozilla account to let you know
              about the changes.</p>

            <p>Termination. These Terms apply until they are modified, or
              until either you or Mozilla decide to end them. You can choose to
              end them at any time for any reason by stopping your use of
              Mozilla.social and deactivating your account. Mozilla can suspend
              or end anyone's access at any time for any reason, including if
              Mozilla decides to end Mozilla.social. If we decide to suspend or
              end your access, we will notify you at the email address
              associated with your account or the next time you attempt to
              access your account.</p>

            <h2 id='california-law-applies'>California Law Applies</h2>

            <p>California law applies to this contract, except California's
              conflict of law provisions. If there is any conflict between this
              English version of the contract and a translation, this English
              version applies.</p>

            <p>You may have other rights under your own country's laws.
              Nothing in these Terms of Service is intended to affect those
              rights.</p>

            <h2>You Can Contact Mozilla</h2>

            <p>If you encounter a content on Mozilla.social that you believe
              is illegal or violates these Terms, you can report it to us by
              clicking on the "report post" link option adjacent to that post,
              and following the prompts that appear.</p>

            <p>To learn more about how Mozilla responds to claims of
              intellectual property infringement, see our <a href='https://www.mozilla.org/about/legal/report-infringement/'>copyright
                or trademark infringement claims policy</a>.</p>

            <p>You can contact Mozilla's Legal Department or notify us of
              legal claims using the information below.</p>

            <p>Mozilla Corporation<br />
              Attn: Mozilla &#8211; Legal Notices<br />
              149 New Montgomery Street<br />
              4th Floor<br />
              San Francisco, CA 94105<br />
              <a href='mailto:legal-notices@mozilla.com'>legal-notices@mozilla.com</a>
            </p>

            <h2 id='translations'>Translations</h2>

            <p>If there is a conflict or ambiguity between a translated
              version of these terms and the English language version, the
              English language version applies.</p>

          </div>
        </div>

        <Helmet>
          <title>Terms of Service</title>
          <meta name='robots' content='all' />
        </Helmet>
      </Column>
    );
  }

}

export default injectIntl(TermsOfService);
